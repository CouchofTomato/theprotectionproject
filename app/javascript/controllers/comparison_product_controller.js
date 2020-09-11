import { Controller } from "stimulus";
import ComparisonProduct from "../services/comparison_product"
import NullProductModuleBenefit from "../nulls/null_product_module_benefit"

export default class extends Controller {
  static targets = ["insurer", "product", "productModules", "comparisonProductSubmit", "insurerTableRow", "productTableRow", "chosenCoverRow", "overallSumAssured", "benefitRow", "productDetailsJSON"]

  addComparisonProduct(event) {
    event.preventDefault()
    this.selectedProductDetails = JSON.stringify(this.submissionData())

    fetch(`/comparison_products`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': this.crsfToken(),
        'Content-Type': 'application/json'
      },
      body: this.selectedProductDetails,
    })
      .then(response => response.json())
      .then(data => this.addSelectedProductToComparison(data)) 
  }

  addSelectedProductToComparison(data) {
    this.comparisonProduct = new ComparisonProduct(data['insurer'], data['product'], data['product_modules'])
    this.addSelectedProductDetails()
    this.addInsurer()
    this.addProduct()
    this.addChosenCover()
    this.addOverallSumAssured()
    this.addBenefits(data['product_modules'])
  }

  crsfToken() {
    let csrfTokenElement = document.querySelector("[name='csrf-token']")
    if(!csrfTokenElement) return ''
    return document.querySelector("[name='csrf-token']").content
  }

  submissionData() {
    return { 
      insurer: this.insurerTarget.value,
      product: this.productTarget.value,
      product_modules: this.selectedProductModules()
    }
  }

  selectedProductModules() {
    let productModules = Array.from(this.productModulesTarget.querySelectorAll("input[type=radio]:checked"))
    return productModules.map(module => module.value)
  }

  addSelectedProductDetails() {
    const cell = this.productDetailsJSONTarget.insertCell()
    cell.dataset.productDetails = this.selectedProductDetails
    cell.dataset.target = "comparison-export.productDetailJSON"
  }

  addInsurer() {
    const cell = this.insurerTableRowTarget.insertCell()
    cell.classList.add("table--fixed-col-width")
    cell.textContent = this.comparisonProduct.insurerName()
  }

  addProduct() {
    const cell = this.productTableRowTarget.insertCell()
    cell.classList.add("table--fixed-col-width")
    cell.textContent = this.comparisonProduct.productName()
  }

  addChosenCover() {
    const cell = this.chosenCoverRowTarget.insertCell()
    cell.classList.add("table--fixed-col-width")
    cell.textContent = this.comparisonProduct.chosenCovers()
  }

  addOverallSumAssured() {
    const cell = this.overallSumAssuredTarget.insertCell()
    cell.classList.add("table--fixed-col-width")
    cell.textContent = this.comparisonProduct.overallSumAssured()
  } 

  addBenefits(product_modules) {
    const nullProductModuleBenefit = new NullProductModuleBenefit()
    this.benefitRowTargets.forEach(benefitRow => {
      const productModuleBenefit = this.comparisonProduct.productModuleBenefit(benefitRow.id) || nullProductModuleBenefit
      const cell = benefitRow.insertCell()
      cell.classList.add("table--fixed-col-width")
      cell.innerHTML = productModuleBenefit.benefit_icon
    })
  }
}
