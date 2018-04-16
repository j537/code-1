import * as React from "react";
import Utility from '../utility';
import './MenuDetails.scss';
import "bootstrap/dist/css/bootstrap.min.css";

interface IProps {
  match: { params: { menu_id: string; } };
}

interface IMenuDetails {
  name: string;
  place: string;
  venue: string;
  event: string;
  pages: Array<IDish[]>;
}

interface IDish {
  id: number;
  name: string;
  description: string;
}

interface IState {
  details: IMenuDetails;
}

const DishDetail = (dish: IDish, key: number) => (
  <div className="dish-detail" key={key}>
    <div>{dish.name}</div>
  </div>
);

const MenuPageSection = (dishes: IDish[], pageNumber: number) => (
  <section className="menu-page-section" key={pageNumber}>
    <h5>Page {pageNumber}</h5>
    {dishes.map((dish, index) => DishDetail(dish, index))}
    <div className="clearfix"></div>
  </section>
);

export default class MenuDetails extends React.Component<IProps, IState> {
  private menuId: number;

  public constructor(props: IProps) {
    super(props);
    this.menuId = parseInt(props.match.params.menu_id, 10);
    this.state = { details: ({ pages: [] } as any) };
  }

  public componentDidMount() {
    fetch(`api/menus/${this.menuId}`)
      .then(Utility.processResponse())
      .then((data) => {
          this.setState({details: data});
      });
  }

  public render() {
    const details = this.state.details;

    return (
      <div className="menu-details">
        <h4>Menu Details</h4>
        <div>Name: {details.name}</div>
        <div>Place: {details.place}</div>
        <div>Venue: {details.venue}</div>
        <div>Event: {details.event}</div>
        { this.state.details.pages.map((mp, index) => MenuPageSection(mp, index + 1))}
      </div>
    );
  }
}
