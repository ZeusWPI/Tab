import { Controller } from "@hotwired/stimulus";

import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    new TomSelect("#transaction_creditor", {
      create: false,
    });
  }
}
