import * as React from "react";
import { ajaxBaseUrl } from '../constants/BaseUrl';

interface IProps {}

interface IState {
  importType: ImportType;
  importing: boolean;
  importFile: File;
}

const enum ImportType {
  Dish = 'Dish',
  Menu = 'Menu',
  MenuPage = 'Menu Page',
  MenuItem = 'Menu Item'
}

const ImportTypeOptions = ["Dish", "Menu", "Menu Page", "Menu Item"].map((v) => <option value={v} key={v}>{v}</option>);

export default class ImportPage extends React.Component<IProps, IState> {
  private readonly importInput: React.RefObject<HTMLInputElement>;

  constructor(props: IProps) {
    super(props);
    this.state = { importType: ImportType.Dish, importing: false, importFile: null}
    this.importInput = React.createRef();
  }

  private handleImport() {
    if (this.state.importFile == null) {
      return;
    }

    const formData = new FormData();
    formData.append("import_file", this.state.importFile);
    this.setState({importing: true});
    fetch(this.getImportUrl(), {
      method: 'POST',
      body: formData
    }).then(() => {
      this.setState({importing: false});
    });
  }

  private getImportUrl(): string {
    let url = ajaxBaseUrl + '/import/';
    switch (this.state.importType) {
      case ImportType.Dish:
        url += 'dishes';
        break;
      case ImportType.Menu:
        url += 'menus';
        break;
      case ImportType.MenuPage:
        url += 'menu_pages';
        break;
      case ImportType.MenuItem:
        url += 'menu_items';
    }

    return url;
  }

  private importTypeSelectorHandler = (event: Event) => {
    this.setState({importType: (event.target as any).value, importFile: null});
    this.importInput.current.value = '';
  }

  private handleFileChange(event: Event) {
    this.setState({importFile: (event.target as HTMLInputElement).files[0]});
  }

  public render() {
    return (
      <div className="import-page">
        <label>Import Type</label>
        <select
          className="form-control import-type-selector"
          onChange={this.importTypeSelectorHandler.bind(this)}
          value={this.state.importType}
        >
          {ImportTypeOptions}
        </select>

        <form onSubmit={this.handleImport.bind(this)}>
          <div className="form-group">
            <label>Upload</label>
            <input className="form-control" type="file"
                   ref={this.importInput}
                   onChange={this.handleFileChange.bind(this)}
                   disabled={this.state.importing}
            >
            </input>
          </div>

          <button type="submit" className="btn btn-primary"
                  disabled={this.state.importing || this.state.importFile == null}>
            {this.state.importing ? 'Importing...' : 'Import'}
          </button>
        </form>
      </div>
    );
  }
}
