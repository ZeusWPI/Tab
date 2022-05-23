import { Controller } from "@hotwired/stimulus"

import React from "react";
import * as ReactDOMClient from 'react-dom/client';

import TransactionForm from "../react/src/components/TransactionForm";

export default class extends Controller {
  connect() {
    const container = document.getElementById('transaction-form');
    const root = ReactDOMClient.createRoot(container);

    root.render(<TransactionForm
      user_name={this.data.get('userName')}
      balance={JSON.parse(this.data.get('balance'))}
      peers={JSON.parse(this.data.get('peers'))}
      csrf_token={JSON.parse(this.data.get('csrfToken'))}
    />);
  }
}
