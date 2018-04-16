import * as React from "react";
import * as $ from 'jquery';
import * as _ from 'lodash';
import 'datatables.net';
import 'datatables.net-dt/css/jquery.dataTables.css';
import { RefObject } from "react";
import * as moment from 'moment';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

import './MenusPage.scss';

interface IProps {
}

interface IState {
  startDate: moment.Moment;
  endDate: moment.Moment;
  filters: {};
}

interface IMenu {
  id: number;
  place: string;
  venue: string;
  event: string;
  sponsor: string;
  date: string;
}

export default class Index extends React.Component<IProps, IState> {
  private tableRef: RefObject<HTMLTableElement>;
  private dataTable: DataTables.Api;
  private exportFormRef: RefObject<HTMLFormElement>;

  constructor(props: IProps) {
    super(props);

    this.tableRef = React.createRef();
    this.exportFormRef = React.createRef();

    this.state = {
      startDate: null,
      endDate: null,
      filters: {},
    };
  }

  public componentDidMount() {
    this.dataTable = $(this.tableRef.current).DataTable({
      ajax: {
        url: 'api/menus',
        dataSrc: 'menus'
      },
      // searching: false,
      serverSide: true,
      scrollY: '400px',
      scrollX:  true,
      scrollCollapse: true,
      lengthMenu: [100, 200, 500, 1000],
      pageLength: 100,
      deferRender: true,
      columnDefs: [
        { width: '20%', targets: [0, 1, 2] },
        { width: '15%', targets: [3, 4] }
      ],
      columns: [
        { data: 'place', name: 'place' },
        { data: 'venue', name: 'venue' },
        { data: 'event', name: 'event' },
        { data: 'sponsor', name: 'sponsor', searchable: false },
        { data: 'date', name: 'date', searchable: false },
        { data: null,
          orderable: false,
          searchable: false,
          render: (data: IMenu) => {
            return `<a href="#/menus/${data.id}">View</a>`;
          }
        }
      ]
    });
  }

  private createSearchableInput(placeholder: string, colIdx: number) {
    return (
      <th className="filterable">
        <input type="text" placeholder={placeholder} onChange={this.filter.bind(this, colIdx)}/>
      </th>
    );
  }

  private filter(colIdx: number, event: Event) {
    const dt = $(this.tableRef.current).DataTable();
    const column = dt.column(colIdx);
    const value = (event.target as HTMLInputElement).value;

    const columnName = this.dataTable.settings().init().columns[colIdx].name;
    const filters = {...this.state.filters};
    (filters as any)[columnName] = value;

    this.setState({filters: filters});
    column.search(value).draw();
  }

  private handleStartDateChange(date: moment.Moment) {
    this.setState({startDate: date}, this.searchHandle);
  }

  private handleEndDateChange(date: moment.Moment) {
    this.setState({endDate: date}, this.searchHandle);
  }

  private searchHandle() {
    let url = 'api/menus';
    const dateRangeParams = this.getDateRangeParams();
    if (dateRangeParams) {
      url += `?${dateRangeParams}`;
    }

    this.dataTable.ajax.url(url).load();
  }

  private getDateRangeParams() {
    if (this.state.startDate == null || this.state.endDate == null) {
      return null;
    }

    const startDate = this.state.startDate.format('YYYY-MM-DD');
    const endDate = this.state.endDate.format('YYYY-MM-DD');
    return `start_date=${startDate}&end_date=${endDate}`;
  }

  // TODO better file download support
  private exportHandle() {
    const form = this.exportFormRef.current;
    let actionUrl = '/api/export/menus';

    const filterParams: string[] = [];
    _.forOwn(this.state.filters, (value, key) => {
      filterParams.push(`${key}=${value}`);
    });

    if (filterParams.length > 0) {
      actionUrl += `?${filterParams.join('&')}`;
    }

    const dateRangeParams = this.getDateRangeParams();
    if (dateRangeParams) {
      if (filterParams.length > 0) {
        actionUrl += `&${dateRangeParams}`;
      } else {
        actionUrl += `?${dateRangeParams}`;
      }
    }

    form.action = actionUrl;
    form.submit();
  }

  public render() {
    return (
      <div className="menus-page">
        <h4>Menus List</h4>

        <div className="advanced-search float-left">
          <div className="date-picker">
            <span>Start Date</span>
            <DatePicker dateFormat="YYYY-MM-DD"
                        selected={this.state.startDate}
                        onChange={this.handleStartDateChange.bind(this)}/>
          </div>

          <div className="date-picker">
            <span>End Date</span>
            <DatePicker dateFormat="YYYY-MM-DD"
                        selected={this.state.endDate}
                        onChange={this.handleEndDateChange.bind(this)}/>
          </div>
        </div>

        <form ref={this.exportFormRef} method="POST" action="/api/export/menus">
        </form>

        <div className="float-right" style={{marginTop: '32px'}}>
          <button type="button" className="btn btn-outline-primary"
                  onClick={this.exportHandle.bind(this)}>Export</button>
        </div>

        <table className="table table-striped table-sm menus-table" ref={this.tableRef}>
          <thead>
          <tr>
            <th>Place</th>
            <th>Venue</th>
            <th>Event</th>
            <th>Sponsor</th>
            <th>Date</th>
            <th></th>
          </tr>
          </thead>
          <tfoot style={{display: 'table-header-group'}}>
          <tr>
            {this.createSearchableInput("Search Place", 0)}
            {this.createSearchableInput("Search Venue", 1)}
            {this.createSearchableInput("Search Event", 2)}
            <th></th>
            <th></th>
            <th></th>
          </tr>
          </tfoot>
          <tbody>
          </tbody>
        </table>
      </div>
    );
  }
}
