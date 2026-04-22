<!--
SYNC IMPACT REPORT
==================
Version Change: 0.0.0 → 1.0.0
Modified Principles: Initial constitution creation
Added Sections: All sections (initial creation)
Removed Sections: None
Templates Requiring Updates:
  ✅ plan-template.md - Aligned with monorepo and type safety principles
  ✅ spec-template.md - Aligned with end-to-end type safety requirements
  ✅ tasks-template.md - Aligned with testing and deployment principles
Follow-up TODOs: None
-->

# Libra AI Constitution

## Core Principles

### I. Monorepo-First Architecture

**Principle**: All development MUST occur within the Turborepo monorepo structure with clear workspace separation.

**Rules**:
- Apps live in `apps/*` (web, builder, cdn, deploy, dispatcher, etc.)
- Shared packages live in `packages/*` (api, db, ui, auth, etc.)
- Tooling configuration lives in `tooling/*`
- Every package MUST have a clear single responsibility
- Cross-package dependencies MUST be explicit in package.json
- Build orchestration MUST use Turborepo with proper task dependencies

**Rationale**: Monorepo architecture enables code sharing, consistent tooling, and coordinated releases across the entire platform while maintaining clear boundaries between concerns.

### II. End-to-End Type Safety (NON-NEGOTIABLE)

**Principle**: Complete TypeScript type coverage from database schema to frontend UI with runtime validation.

**Rules**:
- All code MUST be TypeScript with strict mode enabled
- Database schemas MUST use Drizzle ORM with type inference
- API contracts MUST use tRPC for end-to-end type safety
- All external inputs MUST be validated with Zod v4 (`import { z } from 'zod/v4'`)
- No `any` types except in explicitly justified edge cases
- Type definitions MUST be co-located with implementation or in shared packages

**Rationale**: Type safety prevents entire classes of runtime errors, improves developer experience with autocomplete, and serves as living documentation of data contracts.

### III. Cloudflare-Native Edge-First

**Principle**: All services MUST be designed for Cloudflare Workers edge computing platform.

**Rules**:
- Primary deployment target is Cloudflare Workers
- Use Cloudflare-native services: D1, R2, KV, Hyperdrive, Durable Objects
- Web app MUST use OpenNext.js adapter for Cloudflare deployment
- Edge runtime compatibility MUST be verified (no Node.js-specific APIs)
- Hono framework for edge services (cdn, dispatcher, deploy)
- Workers for Platforms for multi-tenant user project isolation

**Rationale**: Cloudflare edge computing provides global distribution, low latency, and serverless scalability. This is a core differentiator from Vercel-based alternatives.

### IV. Code Quality and Consistency

**Principle**: Uniform code style and quality standards across all workspaces using Biome.

**Rules**:
- Biome ^2.2.2 for linting and formatting (replaces ESLint + Prettier)
- Configuration: 2-space indentation, single quotes, 100 char line width, semicolons as needed
- All code MUST pass `bun format` and `bun lint` before commit
- Conventional Commits format REQUIRED: `feat:`, `fix:`, `chore:`, `refactor:` with optional scope
- No commented-out code in commits (use git history)
- Meaningful variable/function names, avoid abbreviations

**Rationale**: Consistent code style reduces cognitive load, improves collaboration, and enables automated tooling. Biome provides faster, unified linting and formatting.

### V. Testing and Quality Gates

**Principle**: Comprehensive testing strategy with focus on integration and type safety.

**Rules**:
- Vitest 3.2.4+ for all testing
- Test files MUST be named `*.test.ts` and located near source or in `__tests__/`
- Integration tests REQUIRED for: API contracts, database migrations, cross-service communication
- Type checking MUST pass: `bun typecheck`
- All tests MUST pass before merge: `turbo test`
- React Testing Library for component tests
- Isolated tests with minimal setup, no shared state

**Rationale**: Testing prevents regressions, validates contracts, and enables confident refactoring. Type checking catches errors at compile time.

### VI. Database Dual-Architecture

**Principle**: PostgreSQL for business data, Cloudflare D1 for authentication data.

**Rules**:
- **Business Database**: PostgreSQL via Neon + Hyperdrive (packages/db)
- **Auth Database**: Cloudflare D1 SQLite (packages/auth)
- All schema changes MUST use Drizzle migrations
- Migrations MUST be generated: `bun migration:generate`
- Migrations MUST be tested locally before PR: `bun migration:local`
- Foreign key constraints with cascade deletion REQUIRED for data integrity
- No raw SQL except in justified complex queries

**Rationale**: PostgreSQL provides robust relational features for business logic. D1 provides edge-native authentication with global replication. Drizzle ensures type-safe database operations.

### VII. Security and Secrets Management

**Principle**: Zero secrets in code, runtime validation of environment variables.

**Rules**:
- NEVER commit secrets to git
- Use `.env.local` for local development (gitignored)
- Provide `.env.example` with all required variables documented
- Runtime validation using `@t3-oss/env-nextjs` or equivalent
- Cloudflare secrets for production via wrangler
- GitHub Actions secrets for CI/CD
- Stripe webhook signatures MUST be verified
- Turnstile CAPTCHA for sensitive operations

**Rationale**: Secrets in code lead to security breaches. Runtime validation catches configuration errors early. Defense in depth protects user data.

### VIII. AI Integration Standards

**Principle**: Multi-provider AI support with streaming, quota management, and observability.

**Rules**:
- Vercel AI SDK for unified multi-provider interface
- Supported providers: Anthropic Claude, Azure OpenAI, Google Gemini, DeepSeek, xAI
- AI responses MUST use streaming for better UX
- Quota tracking REQUIRED per organization
- Model access MUST be plan-gated (free, pro, enterprise)
- AI Gateway (Cloudflare) for monitoring and cost control
- Structured logging for all AI operations

**Rationale**: Multi-provider support prevents vendor lock-in. Streaming improves perceived performance. Quota management enables sustainable business model.

## Technology Stack Requirements

### Mandatory Technologies

**Build System**:
- Bun 1.2.21+ as primary package manager
- Turborepo 2.5.5+ for monorepo orchestration
- Node.js >= 24 for compatibility

**Frontend**:
- Next.js 15.3.5+ with App Router
- React 19.1.1+ with Server Components
- TypeScript 5.8.3+ strict mode
- Tailwind CSS v4.1.11+ with CSS-in-CSS
- shadcn/ui patterns with Radix UI primitives
- Zod 4.0.14+ for validation (v4 only: `import { z } from 'zod/v4'`)

**Backend**:
- tRPC 11.4.3+ for API layer
- Hono 4.8.10+ for edge services
- Drizzle ORM 0.44.4+ for database
- better-auth 1.3.4+ for authentication

**Infrastructure**:
- Cloudflare Workers for compute
- PostgreSQL (Neon) + Hyperdrive for business data
- Cloudflare D1 for auth data
- Cloudflare R2 for object storage
- E2B 1.2.0-beta.5 or Daytona for sandboxes

### Prohibited Practices

- ❌ Hardcoded secrets or API keys
- ❌ Direct database queries without Drizzle ORM
- ❌ Unvalidated external inputs
- ❌ Non-Cloudflare-compatible Node.js APIs in Workers
- ❌ Magic numbers without named constants
- ❌ Commented-out code in commits
- ❌ `any` types without justification
- ❌ Zod v3 (MUST use v4)

## Development Workflow

### Branch Strategy

- `main` branch is production-ready
- Feature branches: `feature/<description>` or numbered via Spec Kit
- Conventional commit messages REQUIRED
- PR MUST include: description, linked issues, passing CI checks
- Screenshots REQUIRED for UI changes

### Code Review Requirements

- All code MUST be reviewed before merge
- Reviewers MUST verify:
  - Type safety and Zod validation
  - Test coverage for new features
  - Biome formatting and linting pass
  - No secrets in code
  - Documentation updates if needed
  - `.env.example` updated if config changed

### CI/CD Pipeline

- GitHub Actions for all automation
- Validation jobs: typecheck, format, lint, test
- Deployment to Cloudflare Workers on merge to main
- Blacksmith runners for faster builds
- Deployment workflows per service (web, cdn, deploy, dispatcher, etc.)

### Local Development

```bash
# Install dependencies
bun install

# Start all services
bun dev

# Start web app only
bun dev:web

# Type checking
bun typecheck

# Format and lint
bun format:fix && bun lint:fix

# Database migrations
bun migration:generate
bun migration:local

# Run tests
turbo test
```

## Observability and Logging

### Structured Logging

- Component-level categorization (project, auth, deployment, etc.)
- Log levels: error, warn, info, debug
- Context MUST include: userId, orgId, projectId, operation
- No sensitive data in logs (PII, secrets)

### Analytics

- PostHog for product analytics
- Cloudflare AI Gateway for AI usage monitoring
- Performance tracking for critical paths
- Error boundaries for React components

## Open Source and Licensing

### License Compliance

- Project is AGPL-3.0 licensed
- All contributions MUST be compatible with AGPL-3.0
- Commercial licensing available for closed-source deployments
- Third-party dependencies MUST have compatible licenses

### Community Standards

- Code of Conduct MUST be followed (code_of_conduct.md)
- Welcoming to contributors of all skill levels
- Documentation MUST be maintained for public APIs
- Internationalization support (English primary, Chinese secondary via Paraglide.js)

## Governance

### Constitutional Authority

This constitution supersedes all other development practices and guidelines. In case of conflict, this document takes precedence.

### Amendment Process

1. Proposed changes MUST be documented with rationale
2. Impact analysis on existing code and workflows REQUIRED
3. Team consensus or maintainer approval REQUIRED
4. Version bump according to semantic versioning:
   - MAJOR: Breaking changes to core principles
   - MINOR: New principles or significant expansions
   - PATCH: Clarifications, typo fixes, non-semantic changes
5. Migration plan REQUIRED for breaking changes
6. Update dependent templates and documentation

### Compliance Verification

- All PRs MUST verify constitutional compliance
- Automated checks where possible (CI/CD)
- Manual review for architectural decisions
- Complexity MUST be justified against simplicity principle

### Living Documentation

- `AGENTS.md`: Repository guidelines for AI agents
- `TECHNICAL_GUIDELINES.md`: Detailed technical implementation guide
- `clean_code.md`: Code quality and best practices
- `README.md`: Project overview and quick start
- This constitution: Core principles and governance

**Version**: 1.0.0 | **Ratified**: 2025-04-22 | **Last Amended**: 2025-04-22
