import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["input", "results", "selectedList", "hidden"]
	static values = { url: String }

	connect() {
		this.selectedBands = this.loadExistingBands()
		this.initializeRemoveButtons()
	}

	loadExistingBands() {
		try {
			return JSON.parse(this.hiddenTarget.value || "[]")
		} catch (e) {
			return []
		}
	}

	async search() {
		const query = this.inputTarget.value.trim()

		if (query.length < 1) {
			this.resultsTarget.innerHTML = ""
			return
		}

		const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
		const data = await response.json()

		this.displayResults(data, query)
	}

	displayResults(data, query) {
		this.resultsTarget.innerHTML = ""

		// Show existing matches
		data.forEach(band => {
			const div = document.createElement("div")
			div.classList.add("autocomplete-item")
			div.textContent = band.name
			div.addEventListener("click", () => this.addBand(band.id, band.name))
			this.resultsTarget.appendChild(div)
		})

		// If no exact match, show "Create new" option
		const exactMatch = data.find(b => b.name.toLowerCase() === query.toLowerCase())
		if (!exactMatch && query.length > 0) {
			const div = document.createElement("div")
			div.classList.add("autocomplete-item", "create-new")
			div.innerHTML = `<strong>+ Create "${query}"</strong>`
			div.addEventListener("click", () => this.addBand(null, query))
			this.resultsTarget.appendChild(div)
		}
	}

	handleKeydown(event) {
		if (event.key === "Enter") {
			event.preventDefault()
			const query = this.inputTarget.value.trim()
			if (query.length > 0) {
				this.addBand(null, query)  // null id means create new
			}
		}
	}

	addBand(id, name) {
		// Check if already added (by name for new, by id for existing)
		const exists = id
			? this.selectedBands.find(b => b.id === id)
			: this.selectedBands.find(b => b.name.toLowerCase() === name.toLowerCase())

		if (exists) {
			this.inputTarget.value = ""
			this.resultsTarget.innerHTML = ""
			return
		}

		this.selectedBands.push({ id, name })
		this.hiddenTarget.value = JSON.stringify(this.selectedBands)

		this.createBadge(id, name)

		this.inputTarget.value = ""
		this.resultsTarget.innerHTML = ""
	}

	createBadge(id, name) {
		const badge = document.createElement("div")
		badge.className = "badge badge-lg badge-primary gap-2"
		badge.setAttribute("data-band-id", id || "new")
		badge.setAttribute("data-band-name", name)
		badge.innerHTML = `
			${name}
			<button type="button" class="remove-band" data-action="click->band-autocomplete#removeBand">×</button>
		`

		this.selectedListTarget.appendChild(badge)
	}

	removeBand(event) {
		const badge = event.target.closest("[data-band-id]")
		const bandId = badge.getAttribute("data-band-id")
		const bandName = badge.getAttribute("data-band-name")

		// Remove from selectedBands array
		if (bandId === "new") {
			this.selectedBands = this.selectedBands.filter(b => b.name !== bandName)
		} else {
			this.selectedBands = this.selectedBands.filter(b => String(b.id) !== bandId)
		}

		this.hiddenTarget.value = JSON.stringify(this.selectedBands)
		badge.remove()
	}

	initializeRemoveButtons() {
		// Initialize remove buttons for existing bands (when editing)
		this.selectedListTarget.querySelectorAll(".remove-band").forEach(btn => {
			btn.setAttribute("data-action", "click->band-autocomplete#removeBand")
		})
	}
}
