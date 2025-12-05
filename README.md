# Create a .env file
- API_KEY=your_trakt_client_id
- client_id=your_trakt_client_id
- client_secret=your_trakt_client_secret
- tmdb=your_tmdb_api_key_here
- PORT=63355
- BASE_URL=https://trakt-tv.my.domain.com # use http://127.0.0.1:63355 when running locally

# Important Notes
- In your Trakt API application settings (https://trakt.tv/oauth/applications), add your BASE_URL (defined in the .env file) to the list of redirect URIs.
- Verify that the client_id and client_secret stored in your .env file match the credentials shown for this app in the Trakt dashboard.

# Build and Run
- npm install
- npm run Build
- npm start
