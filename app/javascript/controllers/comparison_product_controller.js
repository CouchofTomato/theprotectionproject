import { Controller } from "stimulus";
import ComparisonProduct from "../services/comparison_product"
import NullProductModuleBenefit from "../nulls/null_product_module_benefit"

export default class extends Controller {
  static targets = ["insurer", "product", "productModules", "comparisonProductSubmit", "insurerTableRow", "productTableRow", "chosenCoverRow", "overallSumAssured", "benefitRow"]

  addComparisonProduct(event) {
    event.preventDefault()

    fetch(`/comparison_products`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': this.crsfToken(),
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(this.submissionData()),
    })
      .then(response => response.json())
      .then(data => this.addSelectedProductToComparison(data)) 
  }

  addSelectedProductToComparison(data) {
    this.comparisonProduct = new ComparisonProduct(data['insurer'], data['product'], data['product_modules'])
    this.addInsurer()
    this.addProduct()
    this.addChosenCover()
    this.addOverallSumAssured()
    this.addBenefits(data['product_modules'])
  }

  crsfToken() {
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

  addInsurer() {
    this.insurerTableRowTarget.insertCell()
      .textContent = this.comparisonProduct.insurerName()
  }

  addProduct() {
    this.productTableRowTarget.insertCell()
      .textContent = this.comparisonProduct.productName()
  }

  addChosenCover() {
    this.chosenCoverRowTarget.insertCell()
      .textContent = this.comparisonProduct.chosenCovers()
  }

  addOverallSumAssured() {
    this.overallSumAssuredTarget.insertCell()
      .textContent = this.comparisonProduct.overallSumAssured()
  } 

  addBenefits(product_modules) {
    const nullProductModuleBenefit = new NullProductModuleBenefit()
    this.benefitRowTargets.forEach(benefitRow => {
      const productModuleBenefit = this.comparisonProduct.productModuleBenefit(benefitRow.id) || nullProductModuleBenefit
      benefitRow.insertCell()
        .innerHTML = productModuleBenefit.benefit_icon
    })
  }
}
