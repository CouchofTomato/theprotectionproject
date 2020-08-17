import { Controller } from "stimulus";
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["insurer", "product"];

  getProducts(event) {
    this.productTarget.length = 1
    if (this.insurerTarget.value == '') return;

    fetch(`/insurers/${this.insurerTarget.value}/products`, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => this.addProductsToSelect(data))
  }

  addProductsToSelect(products) {
    let productSelect = this.productTarget

    products.forEach((product, index) => {
      const option = new Option(product.name, product.id)
      productSelect.add(option, undefined)
    })
  }
}

