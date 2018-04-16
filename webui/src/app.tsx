import * as React from "react";
import * as ReactDOM from "react-dom";
import { Route, HashRouter} from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";

import MenusPage from './pages/MenusPage';
import ImportPage from './pages/ImportPage';
import MenuDetails from './pages/MenuDetails';

const App = () => (
  <HashRouter>
    <div className="container">
      <ul className="nav justify-content-center">
        <li className="nav-item">
          <a className="nav-link" href="#/">Menus List</a>
        </li>
        <li className="nav-item">
          <a className="nav-link" href="#/import">Import</a>
        </li>
      </ul>

      <Route exact path="/" component={MenusPage} />
      <Route path="/import" component={ImportPage} />
      <Route path="/menus/:menu_id" component={MenuDetails} />
    </div>
  </HashRouter>
);

ReactDOM.render((
  <App />
), document.getElementById('root'))
