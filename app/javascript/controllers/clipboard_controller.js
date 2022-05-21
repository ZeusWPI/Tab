import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source" ]

  copy() {
    console.log("Sup");
    navigator.clipboard.writeText(this.sourceTarget.value)
  }
}
