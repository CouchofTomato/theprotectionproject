import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["option", "productDetailsJSON", "productDetailJSON"]

  excelExport(event) {
    const queryParams = this.parameterise()
    const url = `/comparisons/show.xlsx?${queryParams}`
    window.location = url
  }

  parameterise() {
    return [this.selectedProductParameters(), this.optionParameters()].join("&")
  }

  selectedProductParameters() {
    return this.productDetailJSONTargets.map(target => {
      const dataParams = JSON.parse(target.dataset.productDetails)
      return this.selectedProductQueryString(dataParams)
    }).join("&")
  }

  selectedProductQueryString(dataParams) {
    return Object.entries(dataParams).map(([key, val]) => {
      if(typeof val === "object") {
        return Object.entries(val).map(([key2, val2]) => encodeURI(`selected_products[][${key}][${key2}]=${val2}`)).join('&')
      } else {
        return(encodeURI(`selected_products[][${key}]=${val}`))
      }
    }).join("&")
  }

  optionParameters() {
    return this.selectedOptions()
      .map(option => `options[]=${option}`)
      .join("&")
  }

  selectedOptions() {
    return this.optionTargets
      .filter(option => option.checked)
      .map(option => option.value)
  }
}

