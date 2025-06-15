graph TD
    A[User] --> B[UI Layer]
    B --> C[Business Logic]
    C --> D[Data Layer]

    subgraph UI[UI Layer]
        B --> E[Pages]
        B --> F[Components]
        B --> G[Theme]
    end

    subgraph Logic[Business Logic]
        C --> H[Auth Service]
        C --> I[Chat Service]
    end

    subgraph Data[Data Layer]
        D --> J[Firebase]
        J --> K[Authentication]
        J --> L[Firestore]
    end
