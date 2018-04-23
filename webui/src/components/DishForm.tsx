import * as React from "react";
import { FormGroup, ControlLabel, FormControl, Button} from 'react-bootstrap';
import Modal from 'react-modal';
import './DishForm.scss'

const customStyles = {
  content : {
    width: '50%',
    top: '50%',
    left: '50%',
    right: 'auto',
    bottom: 'auto',
    marginRight: '-50%',
    transform: 'translate(-50%, -50%)'
  }
};

interface IProps {
  dish: IDish;
  handleSubmit: any;
  handleTogglFrom: any;
  handleChange: any;
  show: boolean;
}

interface IState {
  dish: IDish;
}

interface IDish {
  id: number;
  name: string;
  description: string;
}

Modal.setAppElement('#root')



export default class DishForm extends React.Component<IProps, IState> {

  constructor(props: IProps) {
    super(props);
    this.state = {
      dish: this.props.dish || {id: 0, name: '', description: ''},
    };
  }

  public render(){
    return(
      <div className="form-modal">
        <Modal
         isOpen={this.props.show}
         onRequestClose={this.props.handleTogglFrom}
         style={customStyles}
         contentLabel="Example Modal"
         >
          <div>
            <h2>{this.props.dish.id ? "Edit Dish" : "Add a Dish"}</h2>
            <hr/>
          </div>
          <form>
            <FormGroup>
              <ControlLabel>Name</ControlLabel>
              <FormControl
                name="name"
                type="text"
                value={this.props.dish.name || ''}
                placeholder="Enter name"
                onChange={this.props.handleChange}
              />
            </FormGroup>
            <FormGroup>
              <ControlLabel>Description</ControlLabel>
              <FormControl
                name="description"
                type="text"
                value={this.props.dish.description || ''}
                placeholder="Enter description"
                onChange={this.props.handleChange}
              />
            </FormGroup>
          </form>
          <div className="submit-button">
            <Button bsStyle="primary" onClick={this.props.handleSubmit(this.props.dish)}>Submit</Button>
          </div>
        </Modal>
      </div>
    );
  }
}
