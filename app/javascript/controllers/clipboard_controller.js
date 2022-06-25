import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source" ]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value)

    const clipboardIcon = this.sourceTarget.parentElement.getElementsByClassName('clipboard-icon')[0]
    clipboardIcon.classList.add('animate-wiggle');

    setTimeout(() => {
      clipboardIcon.classList.remove('animate-wiggle');
    }, 1000);
  }
}
