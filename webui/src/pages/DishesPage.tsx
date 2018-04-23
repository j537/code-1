import * as React from "react";
import { axiosClient as axios } from '../constants/BaseUrl';
import { FormGroup, ControlLabel, FormControl, Button } from 'react-bootstrap';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import './DishesPage.scss';
import DishForm from '../components/DishForm';

interface IProps {}

interface IState {
  loading: boolean;
  dishes: Array<IDish>;
  searchName: string;
  activePage: number;
  totalPage: number;
  selectedDish: any;
  showForm: boolean;
}

interface IDish {
  id: number;
  name: string;
  description: string;
  menus_appeared: string;
  times_appeared: string;
  lowest_price: number;
  highest_price: number;
}

export default class DishesPage extends React.Component<IProps, IState> {

  constructor(props: IProps) {
    super(props);
    this.state = {
      loading: false,
      dishes: [],
      searchName: '',
      activePage: 1,
      totalPage: 1,
      selectedDish: {} as any ,
      showForm: false,
    }
  }

  private handleSearchNameChange = (e) => {
    this.setState({searchName: e.target.value}, this.fetchDishes);
  }

  private handlePreviousPage = () => {
    this.setState({activePage: this.state.activePage - 1}, this.fetchDishes);
  }

  private handleNextPage = () => {
    this.setState({activePage: this.state.activePage + 1}, this.fetchDishes);
  }

  private handleChange = (e) => {
    let dish = this.state.selectedDish;
    dish[e.target.name] = e.target.value;
    this.setState({selectedDish: dish});
  }


  private fetchDishes = () => {
    axios.get('/api/dishes', {
      params: {
        name: this.state.searchName,
        page: this.state.activePage
      }
    })
    .then((response) => {
      this.setState({dishes: response.data.dishes, totalPage: response.data.totalPage});
      // console.log(this.state);
    })
    .catch((error) => {
      this.setState({dishes: []});
    });
  }

  private addDish = (dish) => {
    axios.post('/api/dishes', dish)
    .then((response) => {
      this.fetchDishes();
      this.setState({showForm: false});
    })
    .catch((error) => {
      console.log(error.response.data.error);
      toast(error.response.data.error);
    })
  }

  private updateDish = (dish) => {
    axios.put(`/api/dishes/${dish.id}`, dish)
    .then((response) => {
      this.fetchDishes();
      this.setState({showForm: false});
    })
    .catch((error) => {
      console.log(error.response.data.error);
      toast(error.response.data.error);
    })
  }

  private deleteDish = (id) => {
    axios.delete(`/api/dishes/${id}`)
    .then((response) => {
      this.fetchDishes();
    })
    .catch((error) => {
      console.log(error.response.data.error);
      toast(error.response.data.error);
    })
  }

  private handleSubmit = (dish) => {
    return (e) => {
      console.log("handle submit");
      console.log(dish);
      if(dish.id)
      {
        this.updateDish(dish);
      }
      else{
        this.addDish(dish);
      }
    }
  }

  private handleEdit = (id) => {
    return (e) => {
      this.setState({
        selectedDish: this.state.dishes.find(dish => dish.id == id)
      }, () => {
        this.setState({showForm: true});
      });
    }
  }

  private handleDelete = (id) => {
    return (e) => {
      this.deleteDish(id);
    }
  }

  private toggleForm = () => {
    // console.log(this.state);
    this.setState({
      showForm: !this.state.showForm,
      selectedDish: {},
    });
  }

  public componentDidMount() {
    this.fetchDishes();
  }

  public render() {
    return (
      <div className="dishes-container">
        <ToastContainer />
        <div className="dishes-header">
          <div className="dishes-form">
            <form>
              <FormGroup>
                <ControlLabel>Search dishes by name</ControlLabel>
                <FormControl
                  type="text"
                  value={this.state.searchName}
                  placeholder="Enter name"
                  onChange={this.handleSearchNameChange}
                />
              </FormGroup>
            </form>
          </div>
          <Button bsStyle="primary" onClick={this.toggleForm}>Add a dish</Button>
        </div>
        <div className="dish-page">
          {
            this.state.dishes.map((dish, index) => {
              return (
                <div className="dish">
                  <div className="content">
                    <div>{dish.name}</div>
                    <div>{dish.description}</div>
                    <br/>
                    <div>menus: {dish.menus_appeared}</div>
                    <div>times: {dish.times_appeared}</div>
                    <div>price: {dish.lowest_price} - {dish.highest_price} </div>
                  </div>
                  <div className="actions">
                    <Button bsStyle="info" onClick={this.handleEdit(dish.id)}>Edit</Button>
                    <Button bsStyle="warning" onClick={this.handleDelete(dish.id)}>Delete</Button>
                  </div>
                </div>
              )
            })
          }
        </div>
        <div className="pagination">
          <Button bsStyle="info" onClick={this.handlePreviousPage} disabled={this.state.activePage == 1}>Previous Page</Button>
          <Button bsStyle="info" onClick={this.handleNextPage} disabled={this.state.activePage == this.state.totalPage}>Next Page</Button>
        </div>
        <div id="form-model">
        </div>
        <DishForm
          show={this.state.showForm}
          dish={this.state.selectedDish}
          handleSubmit={this.handleSubmit}
          handleTogglFrom={this.toggleForm}
          handleChange={this.handleChange}
          />
      </div>
    );
  }
}
