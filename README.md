# Dungeon Hunter website files

This folder is ready to publish as a static website. `index.html` is the game entry point. The Supabase setup SQL is included for the online leaderboard.

## Publish with GitHub Pages

1. Create a GitHub repository for the game.
2. Upload the files in this folder to the repository root. Keep the game file named `index.html`.
3. In the repository, open **Settings → Pages**.
4. Under **Build and deployment**, choose **Deploy from a branch**, select your default branch and `/(root)`, then save.
5. Wait for the Pages deployment to finish. Share the website URL GitHub provides.
6. For each game update, replace `index.html` in the repository and commit the change. GitHub Pages republishes to the same URL.

## Online leaderboard

If the Supabase leaderboard table and anonymous sign-in are not set up yet, follow the comments in `leaderboard-supabase-setup.sql` and run it in the Supabase SQL Editor. The browser game should contain only the Supabase project URL and publishable key. Never place your database password or a service-role key in this public repository.

The game is a browser-based static site; visitors need an internet connection for the online Supabase leaderboard library and service.
