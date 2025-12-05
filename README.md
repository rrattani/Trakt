# Create a .env file
- API_KEY=your_trakt_client_id
- client_id=your_trakt_client_id
- client_secret=your_trakt_client_secret
- tmdb=your_tmdb_api_key_here
- PORT=63355
- BASE_URL=https://trakt-tv.my.domain.com # use http://127.0.0.1:63355 when running locally

You would also need to add your the BASE_URL defined in the .env redirect URI of Your API Apps in Trakt Settings: https://trakt.tv/oauth/applications 

Make sure to add the redirect URI the API app, where client_id and client_secret defined in the .env matches in Trakt API App.

# Build and Run
- npm install
- npm run Build
- npm start
