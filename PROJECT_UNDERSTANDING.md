# MakeMyPage - Project Understanding Document

## Executive Summary

**Project Name**: MakeMyPage  
**Base Technology**: Libra AI (Open Source V0/Lovable Alternative)  
**Target Use Case**: LinkedIn Profile PDF + Custom Resume → Portfolio Site Generator  
**Architecture**: Turborepo Monorepo on Cloudflare Workers Infrastructure  
**License**: AGPL-3.0 (with commercial licensing options)

---

## 1. Project Overview

### 1.1 What is Libra AI?

Libra AI is a production-ready AI-native development platform that enables full lifecycle management of web applications through natural language interaction. It's positioned as an open-source alternative to V0 (Vercel) and Lovable, specifically optimized for the Cloudflare Workers ecosystem.

**Key Differentiators**:
- **Open Source**: Full source code access under AGPL-3.0
- **Cloudflare-Native**: Built entirely on Cloudflare infrastructure (vs V0's Vercel focus)
- **Multi-Model AI**: Supports Claude, OpenAI, Gemini, DeepSeek, and more
- **Production-Ready**: Enterprise-grade deployment capabilities
- **Self-Hostable**: Complete control over data and infrastructure

### 1.2 Our Adaptation Strategy

We're leveraging Libra's robust foundation to build a specialized offering:

**Input**: LinkedIn Profile PDF + Custom Resume  
**Processing**: AI-powered content extraction and portfolio generation  
**Output**: Beautiful, production-ready portfolio websites

**Value Proposition**:
- Automated portfolio creation from existing professional documents
- No coding required for end users
- Professional, modern UI/UX out of the box
- One-click deployment to custom domains

---

## 2. Technical Architecture

### 2.1 Monorepo Structure

```
makemypage/ (libra fork)
├── apps/                          # Application services (11 apps)
│   ├── web/                       # Next.js 15 main application (React 19)
│   ├── builder/                   # Vite build service
│   ├── cdn/                       # Hono CDN service
│   ├── deploy/                    # Deployment V2 (Cloudflare Queues)
│   ├── deploy-workflow/           # Deployment V1 (Workflows - deprecated)
│   ├── dispatcher/                # Request routing (Workers for Platforms)
│   ├── auth-studio/               # Authentication console
│   ├── docs/                      # Documentation (Next.js + FumaDocs)
│   ├── email/                     # Email service (React Email)
│   ├── screenshot/                # Screenshot generation
│   └── vite-shadcn-template/      # Project template engine
├── packages/                      # Shared libraries (12 packages)
│   ├── api/                       # tRPC API layer
│   ├── auth/                      # Authentication (better-auth)
│   ├── better-auth-cloudflare/    # Cloudflare auth adapter
│   ├── better-auth-stripe/        # Stripe integration
│   ├── common/                    # Shared utilities
│   ├── db/                        # Database layer (Drizzle ORM)
│   ├── email/                     # Email templates
│   ├── middleware/                # Shared middleware
│   ├── sandbox/                   # Sandbox abstraction (E2B/Daytona)
│   ├── shikicode/                 # Code editor with syntax highlighting
│   ├── templates/                 # Project scaffolding
│   └── ui/                        # Design system (shadcn/ui)
└── tooling/                       # Development tools
    └── typescript-config/         # Shared TS config
```

### 2.2 Core Technology Stack

#### Frontend
- **Framework**: Next.js 15.3.5 (App Router) + React 19.1.1
- **Styling**: Tailwind CSS v4 + shadcn/ui components
- **UI Primitives**: Radix UI (accessible, unstyled components)
- **Animation**: Motion 12.23.11
- **Icons**: Lucide React 0.486.0
- **State Management**: Zustand 5.0.8
- **Forms**: React Hook Form 7.63.0 + Zod v4 validation

#### Backend & API
- **Runtime**: Bun 1.2.19+ (package manager & runtime)
- **Framework**: Hono 4.8.5+ (edge-optimized web framework)
- **API Layer**: tRPC 11.4.3+ (end-to-end type safety)
- **ORM**: Drizzle ORM 0.44.3 with Drizzle Kit
- **Authentication**: better-auth 1.3.3
- **Validation**: Zod v4 (strict type validation)

#### Database Architecture (Dual Setup)
- **Business Data**: PostgreSQL via Neon + Hyperdrive (connection pooling)
- **Auth Data**: Cloudflare D1 (SQLite at the edge)
- **Migrations**: Drizzle Kit for schema management

#### AI Integration
- **SDK**: AI SDK 4.3.19 (Vercel AI SDK)
- **Providers**: 
  - Anthropic Claude (advanced reasoning)
  - Azure OpenAI (enterprise-grade)
  - Google Gemini (multimodal)
  - DeepSeek (cost-effective)
  - xAI (Grok)
  - OpenRouter (model aggregation)
- **Sandbox Execution**: E2B 1.2.0-beta.5 + Daytona (secure code execution)

#### Cloudflare Services (Critical Dependencies)
- **Workers**: Serverless compute platform
- **Durable Objects**: Strong consistency state management
- **D1**: Edge SQLite database
- **KV**: Global key-value storage
- **R2**: Object storage (S3-compatible)
- **Queues**: Async message processing
- **Workflows**: Deployment orchestration
- **Workers for Platforms**: Multi-tenant isolation
- **Hyperdrive**: Database connection acceleration
- **Turnstile**: Smart CAPTCHA
- **Browser Rendering**: Screenshot generation
- **AI Gateway**: AI model monitoring & control
- **Cloudflare for SaaS**: Custom domain management

#### Deployment & Infrastructure
- **Platform**: Cloudflare Workers (edge computing)
- **Adapter**: OpenNext 1.6.2 (Next.js → Cloudflare)
- **Build System**: Turborepo 2.5.5 (monorepo orchestration)
- **Package Manager**: Bun 1.2.19+

#### Development Tools
- **Linter/Formatter**: Biome 2.2.4 (replaces ESLint + Prettier)
- **Testing**: Vitest 3.2.4
- **i18n**: Paraglide.js 2.2.0
- **Type Checking**: TypeScript 5.9.2

### 2.3 Application Services Deep Dive

#### 🌐 Core Web Application (`apps/web`)
- **Purpose**: Main user-facing platform
- **Tech**: Next.js 15 + React 19
- **Features**:
  - AI-driven chat interface for project creation
  - Real-time code editing with syntax highlighting
  - Live preview with HMR (Hot Module Replacement)
  - Project management dashboard
  - GitHub integration (one-way sync)
  - Deployment management
- **Key Dependencies**:
  - `@ai-sdk/anthropic`, `@ai-sdk/azure`, `@ai-sdk/xai`
  - `@libra/api`, `@libra/auth`, `@libra/sandbox`, `@libra/templates`
  - `@tanstack/react-query`, `@tanstack/react-table`
  - `motion`, `shiki`, `react-markdown`

#### 🔨 Build Service (`apps/builder`)
- **Purpose**: Vite-based build engine
- **Features**:
  - Millisecond-level hot startup
  - Code compilation and optimization
  - Production bundle generation
  - Multi-tech-stack support

#### 📺 CDN Service (`apps/cdn`)
- **Purpose**: Static asset management
- **Tech**: Hono framework
- **Features**:
  - File upload/download
  - Image processing & compression
  - Global edge caching
  - R2 storage integration

#### 🚀 Deployment Service V2 (`apps/deploy`)
- **Purpose**: Modern queue-based deployment
- **Tech**: Cloudflare Queues
- **Features**:
  - Batch processing with concurrency control
  - Dead letter queue for failed deployments
  - D1 state management
  - Comprehensive error handling & retry logic
- **Workflow**:
  1. Verify user permissions & quotas
  2. Create sandbox environment (E2B/Daytona)
  3. Sync project files
  4. Execute build (`bun install` & `bun build`)
  5. Deploy to user's Worker via Wrangler API
  6. Update routing, cleanup temp environment

#### 🔀 Dispatcher Service (`apps/dispatcher`)
- **Purpose**: Multi-tenant routing
- **Tech**: Workers for Platforms
- **Features**:
  - Route user domains to Worker instances
  - Dynamic Worker scheduling & lifecycle
  - Custom domain binding
  - SSL certificate handling
  - Unified auth & access control

#### 🔒 Auth Studio (`apps/auth-studio`)
- **Purpose**: Authentication management console
- **Features**:
  - User, org, permission management
  - Subscription lifecycle (Stripe integration)
  - OAuth 2.0 multi-provider support
  - D1 database management UI

#### 📸 Screenshot Service (`apps/screenshot`)
- **Purpose**: Automated preview generation
- **Tech**: Cloudflare Queues + Browser Rendering
- **Features**:
  - Async queue processing
  - Web screenshot generation
  - R2 storage integration
  - Batch processing & error retry

#### 🔨 Template Service (`apps/vite-shadcn-template`)
- **Purpose**: Project scaffolding engine
- **Tech**: Vite + shadcn/ui + Tailwind v4
- **Features**:
  - Pre-configured templates
  - Visual template selection
  - Fast compilation & deployment

---

## 3. Key Packages Analysis

### 3.1 `packages/api` - tRPC API Layer
- **Purpose**: Type-safe API routes
- **Key Routers**:
  - `ai.ts`: AI text generation with quota management
  - Authentication, projects, deployments, organizations
- **Pattern**: End-to-end type safety from DB to client

### 3.2 `packages/auth` - Authentication System
- **Tech**: better-auth 1.3.3
- **Features**:
  - OAuth providers (GitHub, email)
  - Organization & permission system
  - Session management
  - Stripe subscription integration
- **Database**: D1 (SQLite at edge)

### 3.3 `packages/sandbox` - Unified Sandbox Abstraction
- **Purpose**: Provider-agnostic code execution
- **Providers**:
  - **E2B**: Production-ready, SDK-based
  - **Daytona**: Template implementation (needs completion)
- **Features**:
  - Multi-provider support with factory pattern
  - Type-safe interface
  - Retry logic with exponential backoff
  - File operations (batch upload/download)
  - Command execution with validation
  - Health monitoring & readiness checks
- **Security**: Path sanitization, command validation

### 3.4 `packages/templates` - Project Scaffolding
- **Structure**:
  ```typescript
  interface TemplateConfig {
    id: string
    name: string
    runCommand: string
    fileStructure: { [key: string]: { purpose, description } }
    conventions: string[]
    dependencies?: { [key: string]: string }
    scripts?: { [key: string]: string }
  }
  ```
- **Current Template**: `vite-shadcn-template` (170KB config)

### 3.5 `packages/ui` - Design System
- **Foundation**: shadcn/ui + Tailwind CSS v4
- **Components**: Radix UI primitives
- **Theming**: CSS variables for light/dark mode
- **Accessibility**: WCAG compliant

### 3.6 `packages/db` - Database Layer
- **ORM**: Drizzle ORM
- **Schema Management**: Drizzle Kit migrations
- **Type Safety**: Full TypeScript integration
- **Dual Database**:
  - PostgreSQL (Neon + Hyperdrive) for business data
  - D1 (SQLite) for auth data

---

## 4. AI Integration Architecture

### 4.1 AI Workflow (`apps/web/ai/`)

**Core Files**:
- `context.ts`: Manages conversation context & history
- `generate.ts`: Orchestrates AI generation requests
- `models.ts`: Model selection & configuration
- `providers.ts`: AI provider initialization
- `parser.ts`: Response parsing (XML/JSON)
- `prompts/`: System prompts for different scenarios
- `utils.ts`: Helper functions

### 4.2 AI Features in Libra

1. **Natural Language Project Creation**
   - User describes app in chat
   - AI generates complete codebase
   - Real-time preview updates

2. **Code Generation**
   - Component generation
   - API route creation
   - Database schema design
   - Styling & layout

3. **Intelligent Editing**
   - Context-aware modifications
   - Multi-file changes
   - Dependency management

4. **Quota Management**
   - Usage tracking per organization
   - Subscription-based limits
   - Stripe integration for billing

### 4.3 AI Provider Configuration

**Example from `packages/api/src/router/ai.ts`**:
```typescript
// Azure OpenAI setup with AI Gateway
const azure = createAzure({
  resourceName: env.AZURE_RESOURCE_NAME,
  apiKey: env.AZURE_API_KEY,
  apiVersion: 'preview',
  baseURL: `${baseUrl}${accountId}/${gatewayName}/azure-openai/...`
})

// Custom provider with reasoning
const myProvider = customProvider({
  languageModels: {
    'chat-model-reasoning-azure': azure('gpt-4.1-mini'),
  },
})
```

**Reasoning Support**:
- Enabled via `REASONING_ENABLED=true`
- Uses `reasoningEffort: 'medium'` for Azure models
- Enhances prompt quality

---

## 5. Development Workflow

### 5.1 Environment Setup

**Requirements**:
- Node.js >= 24
- Bun >= 1.2.19
- Git >= 2.30.0

**Initial Setup**:
```bash
# Clone repository
git clone https://github.com/nextify-limited/libra.git
cd libra

# Install dependencies
bun install

# Configure environment
cp .env.example .env
# Edit .env with API keys and database URLs

# Initialize databases
cd packages/db && bun db:migrate
cd ../auth && bun db:migrate

# Generate i18n files (optional)
cd apps/web && bun run prebuild
```

### 5.2 Development Commands

```bash
# Start all services
bun dev

# Start web app only (most common)
bun dev:web

# Build all packages
bun build

# Type checking
bun typecheck

# Linting & formatting
bun lint
bun lint:fix
bun format
bun format:fix

# Database operations
bun migration:generate
bun migration:local
bun studio:dev

# Testing
turbo test                    # All tests
cd apps/web && bun test       # Specific app
bun test:watch                # Watch mode

# Deployment
bun preview                   # Preview build
bun deploy                    # Deploy to Cloudflare
bun deploy:cache              # Deploy cache service
```

### 5.3 Local Service Addresses

- **Main App**: http://localhost:3000
- **Email Preview**: http://localhost:3001
- **Auth Studio**: http://localhost:3002
- **Documentation**: http://localhost:3003
- **CDN Service**: http://localhost:3004
- **Build Service**: http://localhost:5173
- **Dispatcher**: http://localhost:3007
- **Deploy Service**: http://localhost:3008
- **Screenshot**: http://localhost:3009

### 5.4 Code Quality Standards

**Biome Configuration** (`biome.json`):
- Indentation: 2 spaces
- Line width: 100 characters
- Quotes: Single
- Semicolons: As needed
- Trailing commas: ES5

**TypeScript**:
- Strict mode enabled
- Zod v4 for validation: `import { z } from 'zod/v4'`
- Meaningful variable names
- Feature-oriented folder structure

**Testing**:
- Framework: Vitest
- Location: `__tests__/` or `*.test.ts` adjacent to source
- Isolated, reliable tests

**Commits**:
- Conventional Commits: `feat:`, `fix:`, `chore:`, `refactor:`
- Optional scope: `feat(web): add portfolio generator`

---

## 6. Deployment Architecture

### 6.1 Platform Deployment (Libra Itself)

All services deploy to Cloudflare Workers via GitHub Actions:
- `.github/workflows/web.yml` - Main application
- `.github/workflows/cdn.yml` - CDN service
- `.github/workflows/deploy.yml` - Deployment service
- `.github/workflows/dispatcher.yml` - Routing service
- `.github/workflows/screenshot.yml` - Screenshot service
- `.github/workflows/docs.yml` - Documentation

### 6.2 User Project Deployment (PaaS)

**Workers for Platforms Architecture**:
1. Each user project = independent Worker
2. Dispatcher routes custom domains to Workers
3. Process-level isolation via Workers for Platforms
4. Custom domain binding with auto SSL

**Deployment Flow**:
```
User triggers deploy
  ↓
Queue job (Cloudflare Queues)
  ↓
Create sandbox (E2B/Daytona)
  ↓
Sync files to sandbox
  ↓
Execute build (bun install && bun build)
  ↓
Deploy to Worker via Wrangler API
  ↓
Update dispatcher routing
  ↓
Cleanup sandbox
  ↓
Generate screenshot (async)
```

**Deployment Services**:
- **V2 (Current)**: Cloudflare Queues - batch processing, dead letter queue
- **V1 (Deprecated)**: Cloudflare Workflows - step-by-step orchestration

---

## 7. Scope for Improvements & Customization

### 7.1 What to Strip/Modify

**Remove (Not Needed for Portfolio Generator)**:
1. **Multi-project Management**: Simplify to single portfolio per user
2. **Complex AI Chat Interface**: Replace with guided form-based input
3. **Live Code Editor**: Not needed if we're generating from templates
4. **GitHub Integration**: Optional for MVP
5. **Subscription Tiers**: Start with single pricing or freemium

**Simplify**:
1. **Template System**: Focus on 3-5 portfolio templates instead of generic web apps
2. **Deployment Options**: Single-click deploy only (no custom domains in MVP)
3. **Authentication**: Email-only (remove OAuth complexity initially)

### 7.2 What to Add

**PDF/Resume Processing**:
1. **PDF Parser**: Extract text, structure, images from LinkedIn PDF
2. **Resume Parser**: Support common formats (PDF, DOCX)
3. **Content Extraction**:
   - Personal info (name, title, contact)
   - Work experience
   - Education
   - Skills
   - Projects
   - Certifications
   - Languages

**AI Enhancement**:
1. **Content Summarization**: AI-powered professional summaries
2. **Skill Categorization**: Auto-group skills by domain
3. **Project Highlighting**: Identify key achievements
4. **Tone Adjustment**: Professional, creative, technical variants

**Portfolio Templates**:
1. **Developer Portfolio**: Code-focused, GitHub integration
2. **Designer Portfolio**: Visual-heavy, project showcases
3. **Business Professional**: Corporate, achievement-focused
4. **Creative Portfolio**: Artistic, multimedia-rich
5. **Academic Portfolio**: Research, publications, teaching

**Customization Options**:
1. **Color Schemes**: Pre-defined palettes
2. **Layout Variants**: Single-page, multi-page, sidebar
3. **Section Ordering**: Drag-and-drop section arrangement
4. **Content Visibility**: Show/hide sections
5. **Custom Domain**: (Post-MVP)

### 7.3 Technical Enhancements

**Performance**:
1. **Template Caching**: Pre-build common templates
2. **PDF Processing**: Optimize for large files (>10MB)
3. **Image Optimization**: Compress profile photos, project images

**User Experience**:
1. **Progress Indicators**: Multi-step wizard with clear progress
2. **Preview Mode**: Live preview during customization
3. **Export Options**: PDF, HTML, GitHub Pages
4. **Analytics**: Basic visitor tracking (optional)

**Security**:
1. **File Upload Validation**: Strict PDF/DOCX validation
2. **Content Sanitization**: Prevent XSS in user content
3. **Rate Limiting**: Prevent abuse of AI generation

### 7.4 Architecture Improvements

**Database Schema**:
```sql
-- New tables needed
portfolios (
  id, user_id, template_id, 
  content_json, customization_json,
  deployed_url, created_at, updated_at
)

resume_uploads (
  id, user_id, file_path, 
  parsed_content_json, status,
  created_at
)

portfolio_templates (
  id, name, description,
  preview_url, config_json,
  is_active
)
```

**New API Routes** (tRPC):
```typescript
// packages/api/src/router/portfolio.ts
portfolioRouter = {
  uploadResume: protectedProcedure,
  parseResume: protectedProcedure,
  generatePortfolio: protectedProcedure,
  customizePortfolio: protectedProcedure,
  deployPortfolio: protectedProcedure,
  listTemplates: publicProcedure,
}
```

**New Packages**:
```
packages/
├── pdf-parser/           # PDF extraction (pdf-parse, pdfjs-dist)
├── resume-parser/        # Resume parsing logic
├── portfolio-templates/  # Portfolio-specific templates
└── content-ai/          # AI content enhancement
```

---

## 8. Implementation Roadmap

### Phase 1: Foundation (Weeks 1-2)
- [ ] Fork Libra repository
- [ ] Strip unnecessary features (multi-project, complex editor)
- [ ] Set up development environment
- [ ] Configure Cloudflare services
- [ ] Database schema design

### Phase 2: Core Features (Weeks 3-5)
- [ ] Implement PDF parser
- [ ] Build resume parser
- [ ] Create content extraction pipeline
- [ ] Integrate AI for content enhancement
- [ ] Design 3 initial portfolio templates

### Phase 3: User Interface (Weeks 6-7)
- [ ] Build upload interface
- [ ] Create template selection UI
- [ ] Implement customization wizard
- [ ] Add live preview
- [ ] Polish user experience

### Phase 4: Deployment (Week 8)
- [ ] Integrate with existing deployment service
- [ ] Test end-to-end workflow
- [ ] Implement error handling
- [ ] Add analytics

### Phase 5: Testing & Launch (Weeks 9-10)
- [ ] User acceptance testing
- [ ] Performance optimization
- [ ] Security audit
- [ ] Documentation
- [ ] Soft launch

---

## 9. Key Technical Decisions

### 9.1 Why Keep Libra's Architecture?

**Pros**:
✅ Production-ready infrastructure  
✅ Cloudflare Workers = global edge deployment  
✅ Proven AI integration patterns  
✅ Robust authentication & billing  
✅ Scalable multi-tenant architecture  
✅ Active development & community  

**Cons**:
❌ Complex for simple use case  
❌ Learning curve for team  
❌ Potential over-engineering  
❌ AGPL license implications  

**Decision**: Keep core architecture, simplify user-facing features

### 9.2 Database Strategy

**Keep Dual Database**:
- PostgreSQL (Neon): Portfolio data, user content
- D1 (SQLite): Authentication, sessions

**Rationale**: Leverage Cloudflare edge for auth, centralized DB for content

### 9.3 AI Provider Selection

**Recommended Stack**:
1. **Primary**: Claude 3.5 Sonnet (best for content generation)
2. **Fallback**: Azure OpenAI (enterprise reliability)
3. **Cost-Effective**: DeepSeek (high volume processing)

**Use Cases**:
- Claude: Professional summaries, skill categorization
- Azure: Bulk content processing
- DeepSeek: Template population, basic formatting

### 9.4 Template System

**Approach**: Extend `packages/templates` with portfolio-specific configs

**Structure**:
```typescript
interface PortfolioTemplate extends TemplateConfig {
  category: 'developer' | 'designer' | 'business' | 'creative' | 'academic'
  sections: {
    hero: boolean
    about: boolean
    experience: boolean
    education: boolean
    skills: boolean
    projects: boolean
    contact: boolean
  }
  colorSchemes: ColorScheme[]
  layoutVariants: LayoutVariant[]
}
```

---

## 10. Risks & Mitigations

### 10.1 Technical Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| PDF parsing accuracy | High | Use multiple parsers (pdf-parse, pdfjs-dist), manual review option |
| AI hallucinations | Medium | Validate extracted content, user review step |
| Cloudflare costs | Medium | Implement usage quotas, optimize Worker execution |
| Template complexity | Low | Start with 3 simple templates, iterate based on feedback |
| Deployment failures | Medium | Robust error handling, retry logic, user notifications |

### 10.2 Business Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| AGPL license compliance | High | Consult legal, consider commercial license from Nextify |
| Market competition | Medium | Focus on LinkedIn integration, rapid iteration |
| User adoption | High | Free tier, excellent UX, marketing |
| Scalability costs | Medium | Usage-based pricing, optimize resource usage |

### 10.3 Operational Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Cloudflare dependency | High | Document all services, have migration plan |
| AI API costs | Medium | Implement caching, rate limiting, cost monitoring |
| Data privacy | High | Clear privacy policy, GDPR compliance, data encryption |
| Support burden | Medium | Comprehensive docs, automated support, community forum |

---

## 11. Success Metrics

### 11.1 Technical KPIs
- **PDF Parse Accuracy**: >95% for standard LinkedIn PDFs
- **Generation Time**: <30 seconds from upload to preview
- **Deployment Success Rate**: >98%
- **Uptime**: >99.9% (Cloudflare SLA)
- **Page Load Speed**: <2 seconds (generated portfolios)

### 11.2 Business KPIs
- **User Conversion**: Upload → Generated Portfolio >80%
- **Deployment Rate**: Generated → Deployed >50%
- **User Satisfaction**: NPS >40
- **Monthly Active Users**: Track growth
- **Revenue per User**: (If monetized)

---

## 12. Resources & Documentation

### 12.1 Official Libra Resources
- **Website**: https://libra.dev
- **Documentation**: https://docs.libra.dev
- **GitHub**: https://github.com/nextify-limited/libra
- **Community Forum**: https://forum.libra.dev

### 12.2 Cloudflare Resources
- **Workers**: https://developers.cloudflare.com/workers/
- **D1**: https://developers.cloudflare.com/d1/
- **R2**: https://developers.cloudflare.com/r2/
- **Queues**: https://developers.cloudflare.com/queues/
- **Workers for Platforms**: https://developers.cloudflare.com/cloudflare-for-platforms/

### 12.3 Key Technologies
- **Next.js 15**: https://nextjs.org/docs
- **React 19**: https://react.dev
- **Tailwind CSS v4**: https://tailwindcss.com/docs
- **shadcn/ui**: https://ui.shadcn.com
- **tRPC**: https://trpc.io/docs
- **Drizzle ORM**: https://orm.drizzle.team/docs
- **better-auth**: https://better-auth.com/docs
- **AI SDK**: https://sdk.vercel.ai/docs

---

## 13. Next Steps

### 13.1 Immediate Actions
1. **Team Alignment**: Review this document with all stakeholders
2. **Environment Setup**: Set up Cloudflare accounts, API keys
3. **Repository Setup**: Fork Libra, configure CI/CD
4. **Prototype**: Build minimal PDF → Portfolio flow

### 13.2 Research Tasks
1. **PDF Parsing**: Evaluate libraries (pdf-parse, pdfjs-dist, pdf.js)
2. **Resume Parsing**: Research existing solutions (Affinda, Sovren, open-source)
3. **Template Design**: Analyze popular portfolio sites
4. **Pricing Strategy**: Research competitor pricing

### 13.3 Technical Spikes
1. **LinkedIn PDF Structure**: Analyze format variations
2. **AI Prompt Engineering**: Optimize for portfolio content
3. **Performance Testing**: Cloudflare Workers limits
4. **Cost Modeling**: Estimate per-user costs

---

## 14. Appendix

### 14.1 Glossary

- **Monorepo**: Single repository containing multiple packages/apps
- **Turborepo**: Build system for monorepos
- **Workers for Platforms**: Cloudflare's multi-tenant Worker deployment
- **Durable Objects**: Cloudflare's strongly consistent storage
- **Hyperdrive**: Database connection pooling service
- **tRPC**: Type-safe RPC framework
- **Drizzle ORM**: TypeScript ORM for SQL databases
- **shadcn/ui**: Component library built on Radix UI
- **E2B**: Secure code execution sandbox
- **OpenNext**: Next.js adapter for Cloudflare

### 14.2 Environment Variables Reference

**Critical Variables** (from `.env.example`):
```bash
# Database
DATABASE_URL=                    # PostgreSQL connection string
HYPERDRIVE_ID=                   # Cloudflare Hyperdrive ID

# Authentication
BETTER_AUTH_SECRET=              # Auth encryption key
GITHUB_CLIENT_ID=                # OAuth (optional for us)
GITHUB_CLIENT_SECRET=

# AI Providers
AZURE_RESOURCE_NAME=
AZURE_API_KEY=
AZURE_DEPLOYMENT_NAME=
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
DEEPSEEK_API_KEY=

# Cloudflare
CLOUDFLARE_ACCOUNT_ID=
CLOUDFLARE_API_TOKEN=
CLOUDFLARE_AIGATEWAY_NAME=

# Sandbox
E2B_API_KEY=
DAYTONA_API_KEY=

# Stripe (if monetizing)
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
```

### 14.3 File Structure Conventions

**Naming**:
- Components: PascalCase (`PortfolioCard.tsx`)
- Utilities: camelCase (`parseResume.ts`)
- Constants: UPPER_SNAKE_CASE (`MAX_FILE_SIZE`)
- Types: PascalCase with `I` prefix for interfaces (`IPortfolio`)

**Organization**:
```
apps/web/
├── app/                    # Next.js App Router
│   ├── (frontend)/        # Public pages
│   ├── (dashboard)/       # Protected pages
│   └── api/               # API routes
├── components/            # React components
│   ├── ui/               # shadcn/ui components
│   ├── portfolio/        # Portfolio-specific
│   └── shared/           # Reusable components
├── lib/                  # Utilities
├── ai/                   # AI integration
└── types/                # TypeScript types
```

---

## Conclusion

Libra AI provides a robust, production-ready foundation for building our LinkedIn-to-Portfolio generator. By leveraging its Cloudflare-native architecture, AI integration, and deployment infrastructure, we can focus on our unique value proposition: seamless portfolio creation from professional documents.

**Key Takeaways**:
1. ✅ Solid technical foundation (Cloudflare Workers, Next.js 15, React 19)
2. ✅ Proven AI integration patterns (multi-provider support)
3. ✅ Scalable deployment architecture (Workers for Platforms)
4. ✅ Modern development experience (Turborepo, Bun, TypeScript)
5. ⚠️ Complexity to manage (strip unnecessary features)
6. ⚠️ AGPL license considerations (consult legal)

**Success Factors**:
- Focus on user experience (simple upload → beautiful portfolio)
- Leverage AI for content enhancement (not just generation)
- Start with MVP (3 templates, basic customization)
- Iterate based on user feedback
- Monitor costs closely (AI, Cloudflare usage)

This document should serve as the single source of truth for the project. Update it as we learn and evolve.

---

**Document Version**: 1.0  
**Last Updated**: 2025-04-19  
**Author**: Development Team  
**Status**: Initial Analysis Complete
