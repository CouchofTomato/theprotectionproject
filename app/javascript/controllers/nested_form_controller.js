import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ["add_item", "template"]

  add_association(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, new Date().valueOf());
    this.add_itemTarget.insertAdjacentHTML('beforeend', content);
  }

  remove_association(event) {
    event.preventDefault()
    const item = event.target.closest("[data-target-id='applicant-section']");
    item.remove();
  }
}
