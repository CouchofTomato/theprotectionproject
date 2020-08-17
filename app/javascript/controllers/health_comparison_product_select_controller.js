import { Controller } from "stimulus";
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["insurer"];

  getProducts(event) {
    if (this.insurerTarget.value == '') return;
  }
}

