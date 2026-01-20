Project Specification: AI Script Studio
 
Concise Overview
AI Script Studio is an AI platform for generating video scripts and written content via OpenRouter. It features content type selection, dynamic forms, AI generation, and script saving for authenticated users, with robust error handling.
 View project at: https://ai-script-studio.zeabur.app/
Pages
•
`/`: Landing Page
•
`/auth`: Email OTP and Anonymous Authentication
•
`/create`: Content Creation (Type Selection, Form Input, AI Generation, Result Display)
•
`/*`: Not Found Page
 
File Tree
.
└── src/
    ├── components/
    │   ├── create/
    │   │   ├── ContentTypeSelector.tsx
    │   │   ├── ScriptForm.tsx
    │   │   └── ScriptResult.tsx
    │   ├── AnimatedBackground.tsx
    │   ├── ErrorBoundary.tsx
    │   └── LogoDropdown.tsx
    ├── convex/
    │   ├── ai.ts
    │   ├── auth/
    │   │   └── emailOtp.ts
    │   ├── auth.config.ts
    ├── auth.ts
    ├── debug.ts
    ├── http.ts
    ├── schema.ts
    ├── scripts.ts
    └── users.ts
    ├── hooks/
    │   ├── use-auth.ts
    │   └── use-mobile.ts
    ├── lib/
    │   ├── utils.ts
    │   └── vly-integrations.ts
    ├── pages/
    │   ├── Auth.tsx
    │   ├── Create.tsx
    │   ├── Landing.tsx
    │   └── NotFound.tsx
    ├── instrumentation.tsx
    └── main.tsx
 
Project-wide Logic
 
Business Logic
Users select content types, provide inputs, and AI generates tailored content. Authenticated users can save generated scripts.
 
Technical Logic
•
Frontend: React handles UI/forms. `src/pages/Create.tsx` displays granular, user-friendly client-side error toasts for OpenRouter API issues (missing/invalid API key, insufficient credits, rate limiting, generation timeouts) by parsing `ConvexError` messages. Input sanitization prevents serialization issues.
•
Authentication: Convex Auth (Anonymous, Email OTP via `src/convex/auth.ts`, `src/convex/auth/emailOtp.ts`). `src/convex/users.ts` manages `currentUser` via `ctx.auth.getUserIdentity()`, returning `null` on error with logging. `useAuth` hook (`src/hooks/use-auth.ts`) conditionally queries `currentUser` only when authenticated. `src/convex/schema.ts` defines users table.
•
Backend & Database: Convex. `src/convex/schema.ts` defines scripts/users tables. `src/convex/ai.ts` handles AI generation via OpenRouter (axios) directly, including model selection, prompt engineering, comprehensive logging, and a 60-second timeout. Robust `ConvexError` handling covers missing/invalid/empty `OPENROUTER_API_KEY` (strictly from env vars, no fallback), credits, rate limits, and timeouts. Non-essential headers are omitted. `src/convex/scripts.ts` manages script saving/retrieval. `src/convex/debug.ts` checks env vars like `OPENROUTER_API_KEY`.
 
Other Relevant Information
•
Structure: Global client-side error handling via `src/instrumentation.tsx` and `src/components/ErrorBoundary.tsx`.
•
Integrations: Convex, Framer Motion, Shadcn UI. OpenRouter is directly used for AI via `src/convex/ai.ts`, bypassing `@vly-ai/integrations` for AI calls.
•
Conventions: Mobile responsive, Sonner notifications.
