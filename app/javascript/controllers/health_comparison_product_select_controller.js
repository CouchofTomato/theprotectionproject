import { Controller } from "stimulus";
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["insurer", "product", "productModules"];

  connect() {
    this.resetForm()
  }

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

  getProductModules(event) {
    if (this.productTarget.value == '') return;

    fetch(`/products/${this.productTarget.value}/product_modules`, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => this.addProductModules(data))
  }

  addProductsToSelect(products) {
    products.forEach((product, index) => {
      const option = new Option(product.name, product.id)
      this.productTarget.add(option, undefined)
    })
  }

  addProductModules(productModules) {
    for (const [category, productModules] of Object.entries(this.groupProductModules(productModules))) {
      const fieldDiv = this.createElement("div", { "class": ["field"] })
      const title = this.createElement("h5", { "class": ["title", "is-5"], "textContent": `${category}` })
      const inputDiv = this.createElement("inputDiv", { "class": ["control"] })
      fieldDiv.appendChild(title)
      productModules.forEach(productModule => {
        const label = this.createElement("label", { "class": ["radio"] })
        const input = this.createElement(
          "input",
          {
            "name": `comparison_product[product_modules][${productModule.category}]`,
            "value": productModule.id,
            "type": "radio"
          }
        )
        label.appendChild(input)
        label.appendChild(document.createTextNode(`${productModule.name}`))
        inputDiv.append(label)
      })
      fieldDiv.appendChild(inputDiv)
      this.productModulesTarget.append(fieldDiv)
    }
  }

  groupProductModules(productModules) {
    return productModules.reduce((obj, productModule) => {
      obj[productModule.category] = obj[productModule.category] || []
      obj[productModule.category].push(productModule)
      return obj
    }, {})
  }

  createElement(type, attributes) {
    const element = document.createElement(type)
    for (let key in attributes) {
      if (key == "class") {
        element.classList.add.apply(element.classList, attributes[key])
      } else {
        element[key] = attributes[key]
      }
    }
    return element
  }

  resetForm(event) {
    this.insurerTarget.value = ''
    this.productTarget.length = 1
    this.productModulesTarget.innerHTML = ''
  }
}

