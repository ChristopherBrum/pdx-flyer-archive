import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["input", "results", "hidden"]
	static values = { url: String }

	async search() {
		const query = this.inputTarget.value.trim()

		if (query.length < 1) {
			this.resultsTarget.innerHTML = ""
			this.hiddenTarget.value = ""
			return
		}

		const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
		const data = await response.json()

		this.displayResults(data, query)
	}

	displayResults(data, query) {
		this.resultsTarget.innerHTML = ""

		// Show existing matches
		data.forEach(item => {
			const div = document.createElement("div")
			div.classList.add("autocomplete-item")
			div.textContent = item.name
			div.addEventListener("click", () => this.selectItem(item))
			this.resultsTarget.appendChild(div)
		})

		// If no exact match, show "Create new" option
		const exactMatch = data.find(item => item.name.toLowerCase() === query.toLowerCase())
		if (!exactMatch && query.length > 0) {
			const div = document.createElement("div")
			div.classList.add("autocomplete-item", "create-new")
			div.innerHTML = `<strong>+ Create "${query}"</strong>`
			div.addEventListener("click", () => this.createNew(query))
			this.resultsTarget.appendChild(div)
		}
	}

	selectItem(item) {
		this.inputTarget.value = item.name
		this.hiddenTarget.value = item.id
		this.resultsTarget.innerHTML = ""
	}

	createNew(name) {
		this.inputTarget.value = name
		this.hiddenTarget.value = ""  // Empty means create new
		this.resultsTarget.innerHTML = ""
	}

	hideResults() {
		setTimeout(() => {
			this.resultsTarget.innerHTML = ""
		}, 200)  // Delay to allow click events to fire
	}
}