# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PDX Flyer Archive is a Rails 8 application for archiving concert flyers from the Portland music scene. It manages flyers, bands, venues, and their relationships with image upload support via Active Storage.

## Core Domain Models

The application uses a many-to-many relationship pattern:
- **Flyer**: Central model with title, event_date, notes, and an attached image (via Active Storage). Belongs to a Venue.
- **Band**: Musicians/groups that perform. Has many Flyers through BandFlyers join table.
- **Venue**: Performance locations. Has many Flyers directly.
- **BandFlyer**: Join table linking Bands and Flyers.

Key model patterns:
- Flyers can have multiple bands via the `band_flyers` join table
- Both Band and Venue support autocomplete search via `search_by_name` scope
- Flyer associations are handled via `FlyerAssociationHandler` concern which processes venue and band assignments from form data
- Flyers accept venue/band associations by ID or name, creating new records when needed (see `assign_venue_from_params` and `assign_bands_from_json` in app/models/flyer.rb)

## Development Commands

### Setup
```bash
bin/setup              # Initial setup: install dependencies, setup database
bin/rails db:migrate   # Run migrations
bin/rails db:seed      # Seed database
```

### Development Server
```bash
bin/dev                # Start Rails server with asset watching (Foreman)
bin/rails server       # Rails server only (port 3000)
```

### Database
```bash
bin/rails db:create               # Create database
bin/rails db:drop                 # Drop database
bin/rails db:reset                # Drop, create, migrate, seed
bin/rails db:migrate              # Run pending migrations
bin/rails db:rollback             # Rollback last migration
bin/rails db:migrate:status       # View migration status
```

### Testing
```bash
bundle exec rspec                 # Run all tests
bundle exec rspec spec/models     # Run model tests
bundle exec rspec spec/path/to/file_spec.rb  # Run specific test file
bundle exec rspec spec/path/to/file_spec.rb:42  # Run specific test at line
```

### Assets
```bash
npm run build          # Build JavaScript with esbuild
npm run build:css      # Build Tailwind CSS
```

The JavaScript build command bundles files from `app/javascript/*.js` into `app/assets/builds/` using esbuild with ESM format.

### Code Quality
```bash
bin/rubocop            # Run Ruby linter
bin/brakeman           # Run security scanner
bundle exec annotate   # Update model schema annotations
```

## Architecture Notes

### Frontend Stack
- **Hotwire**: Uses Turbo for SPA-like navigation and Stimulus for JavaScript controllers
- **Styling**: Tailwind CSS with DaisyUI component library
- **Build Pipeline**: esbuild for JavaScript, Tailwind CLI for CSS
- **Asset Management**: Propshaft (not Sprockets)

### Autocomplete Pattern
The app implements a custom autocomplete system for associating bands and venues with flyers:
- JavaScript in `app/javascript/flyer_autocomplete.js` handles autocomplete UI
- API endpoints in `app/controllers/api/` return JSON for autocomplete searches
- Supports both selecting existing records and creating new ones inline
- Band associations use JSON serialization (`band_ids_json` param) to handle multiple selections
- Venue associations use either ID or name (via `venue_search` param)

### Controller Concerns
- `FlyerAssociationHandler`: Extracts logic for handling venue and band associations from form params, used in FlyersController

### Active Storage
Flyers use Active Storage for image attachments. Images are required and validated in the model.

### Database
- PostgreSQL with multiple databases in production (primary, cache, queue, cable)
- Uses Solid Cache, Solid Queue, and Solid Cable (database-backed adapters for Rails.cache, Active Job, and Action Cable)

### Testing
- RSpec for testing framework (no default tests found in codebase yet)
- Factory Bot and Faker available for test data

## Common Patterns

When creating/updating flyers:
1. Use `FlyerAssociationHandler` concern in controllers
2. Venue assignment: Pass either `venue_id` or `venue_search` param
3. Band assignment: Pass `band_ids_json` with array of `{id, name}` objects
4. The model handles find-or-create logic for new venues/bands

When adding autocomplete:
- Follow pattern in `flyer_autocomplete.js` and API controllers
- Include search scope in model: `scope :search_by_name`
- Return JSON with `id` and `name` attributes
