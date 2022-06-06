import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	toggle() {
		document.getElementById('mobile-menu').classList.toggle('hidden');
		document.getElementById('mobile-menu-hamburger').classList.toggle('hidden');
		document.getElementById('mobile-menu-cross').classList.toggle('hidden');
	}
}
