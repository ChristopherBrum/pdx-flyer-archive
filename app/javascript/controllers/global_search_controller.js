import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["input", "results"]
	static values = { url: String }

	connect() {
		this.debounceTimer = null
	}

	disconnect() {
		if (this.debounceTimer) {
			clearTimeout(this.debounceTimer)
		}
	}

	search() {
		clearTimeout(this.debounceTimer)

		const query = this.inputTarget.value.trim()

		if (query.length < 2) {
			this.resultsTarget.innerHTML = ""
			this.resultsTarget.classList.add("hidden")
			return
		}

		this.debounceTimer = setTimeout(() => {
			this.performSearch(query)
		}, 300)
	}

	async performSearch(query) {
		try {
			const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
			const data = await response.json()

			this.displayResults(data)
		} catch (error) {
			console.error("Search error:", error)
			this.resultsTarget.innerHTML = '<div class="p-4 text-error">Search failed. Please try again.</div>'
		}
	}

	displayResults(data) {
		this.resultsTarget.innerHTML = ""

		if (!data.flyers || data.flyers.length === 0) {
			this.resultsTarget.innerHTML = '<div class="p-4 text-base-content/60">No flyers found</div>'
			this.resultsTarget.classList.remove("hidden")
			return
		}

		data.flyers.forEach(flyer => {
			const resultItem = document.createElement("a")
			resultItem.href = `/flyers/${flyer.id}`
			resultItem.className = "flex gap-3 p-3 hover:bg-base-200 transition-colors border-b border-base-300 last:border-b-0"

			// Image thumbnail
			let imageHtml = ''
			if (flyer.image_url) {
				imageHtml = `
					<div class="flex-shrink-0 w-16 h-16 bg-base-200 rounded overflow-hidden">
						<img src="${flyer.image_url}" class="w-full h-full object-cover" alt="${flyer.title}">
					</div>
				`
			} else {
				imageHtml = `
					<div class="flex-shrink-0 w-16 h-16 bg-base-200 rounded flex items-center justify-center">
						<svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-base-300" fill="none" viewBox="0 0 24 24"
stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16
16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
						</svg>
					</div>
				`
			}

			// Build bands display
			const bandsHtml = flyer.bands && flyer.bands.length > 0
				? `<div class="text-xs text-base-content/70">🎵 ${flyer.bands.join(', ')}</div>`
				: ''

			// Build date display
			const dateHtml = flyer.event_date
				? `<div class="text-xs text-base-content/70">📅 ${flyer.event_date}</div>`
				: ''

			resultItem.innerHTML = `
				${imageHtml}
				<div class="flex-1 min-w-0">
					<div class="font-semibold truncate">${flyer.title}</div>
					<div class="text-sm text-base-content/60 truncate">📍 ${flyer.venue || 'Unknown venue'}</div>
					${bandsHtml}
					${dateHtml}
				</div>
			`

			this.resultsTarget.appendChild(resultItem)
		})

		this.resultsTarget.classList.remove("hidden")
	}

	hide(event) {
		// Only hide if clicking outside the controller element
		if (!this.element.contains(event.target)) {
			this.resultsTarget.classList.add("hidden")
		}
	}

	showIfHasResults() {
		if (this.resultsTarget.children.length > 0) {
			this.resultsTarget.classList.remove("hidden")
		}
	}
}