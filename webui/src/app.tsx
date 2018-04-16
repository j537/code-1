import * as React from "react";
import * as ReactDOM from "react-dom";
import { Route, HashRouter} from "react-router-dom";
import "bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";

import Dashboard from './pages/dashboard/Index';
import ImportPage from './pages/ImportPage';

const App = () => (
  <HashRouter>
    <div className="container">
      <ul className="nav justify-content-center">
        <li className="nav-item">
          <a className="nav-link" href="#/">Dashboard</a>
        </li>
        <li className="nav-item">
          <a className="nav-link" href="#/import">Import</a>
        </li>
      </ul>

      <Route exact path="/" component={Dashboard} />
      <Route path="/import" component={ImportPage} />
    </div>
  </HashRouter>
);

ReactDOM.render((
  <App />
), document.getElementById('root'))
