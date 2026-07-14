# Standalone OmniRoute Gateway Service

This directory contains everything you need to host **OmniRoute** on a separate Render Web Service.

By separating OmniRoute from your main bot service, you will:
1. **Save Bot Memory & CPU:** Free up over 200MB of RAM on your bot's Render service, completely eliminating Out-Of-Memory (OOM) failures and slow model response times.
2. **Increase Reliability:** The OmniRoute gateway will run in its own dedicated container and remain highly responsive.

---

## How to Deploy to Render

### Step 1: Create a separate Git repository
1. Create a new repository on GitHub named `omniroute-service`.
2. Copy the contents of this folder (`Dockerfile` and `entrypoint.sh`) into that new repository.
3. Commit and push the changes to GitHub.

### Step 2: Create Web Service on Render
1. Go to your **Render Dashboard** -> **New** -> **Web Service**.
2. Select the GitHub repository you created (`omniroute-service`).
3. Name your service (e.g. `my-omniroute-gateway`).
4. Select **Docker** as the Runtime.
5. Choose the **Free** tier.

### Step 3: Configure Environment Variables on Render
Add the following variables in the **Environment** tab:
* `GEMINI_API_KEY`: Your Google Gemini API Key.
* `PORT`: `20128` (or leave empty, Render will configure it).

Click **Deploy**! Once deployment is complete, Render will provide a public URL (e.g. `https://my-omniroute-gateway.onrender.com`).

---

## How to connect the Bot to your Standalone OmniRoute

Once your standalone OmniRoute service is live, update your **Bot's Render Service** environment variables:

1. Add/Update **`OMNIROUTE_BASE_URL`**:
   * Value: `https://your-service-name.onrender.com/v1` *(Make sure to replace with your actual URL and end with `/v1`)*
2. Add/Update **`START_LOCAL_OMNIROUTE`**:
   * Value: `false` *(This tells the bot's startup script to SKIP booting the local Node server, instantly freeing up memory!)*
3. Add/Update **`OMNIROUTE_ENABLED`**:
   * Value: `true` *(Enables the bot to route vision/fallbacks to OmniRoute)*

Save changes! Render will redeploy the bot, and it will now use your hosted OmniRoute gateway seamlessly!
