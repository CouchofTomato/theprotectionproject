import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["productDetailsJSON", "productDetailJSON"]

  excelExport(event) {
    const queryParams = this.parameterise()
    console.log(queryParams)
    const url = `/comparisons/show.xlsx?${queryParams}`
    window.location = url
  }

  parameterise() {
    return this.productDetailJSONTargets.map(target => {
      const dataParams = JSON.parse(target.dataset.productDetails)
      return this.queryString(dataParams)
    }).join("&")
  }

  queryString(dataParams) {
    return Object.entries(dataParams).map(([key, val]) => {
      if(typeof val === "object") {
        return Object.entries(val).map(([key2, val2]) => encodeURI(`selected_products[][${key}][${key2}]=${val2}`)).join('&')
      } else {
        return(encodeURI(`selected_products[][${key}]=${val}`))
      }
    }).join("&")
  }
}

