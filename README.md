# AzuraCast on Heroku

Deploy [AzuraCast](https://www.azuracast.com/), a self-hosted web radio management suite, on Heroku using Docker containers. This setup includes optional basic authentication to restrict access to your friends.

## What is AzuraCast?

AzuraCast is a free and open-source self-hosted web radio management suite. It allows you to:
- 🎵 Stream your own radio station
- 📻 Manage playlists and media
- 📊 View listener statistics
- 🎙️ Support for AutoDJ and live streaming
- 🌐 Web-based interface for easy management

## Quick Deploy to Heroku

Click the button below to deploy AzuraCast to Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Deployment Steps

1. **Click the Deploy to Heroku button** above
2. **Fill in the app name** (e.g., `my-radio-station`)
3. **Configure authentication** (recommended):
   - Set `BASIC_AUTH_USER` to a username of your choice
   - Set `BASIC_AUTH_PASSWORD` to a secure password
   - This will restrict access to only people who have these credentials
4. **Click "Deploy app"** and wait for the deployment to complete
5. **Access your radio station** at `https://your-app-name.herokuapp.com`

## Manual Deployment

If you prefer to deploy manually:

```bash
# Clone this repository
git clone https://github.com/santi-rios/ladoB.git
cd ladoB

# Login to Heroku
heroku login

# Create a new Heroku app
heroku create your-app-name

# Set the stack to container
heroku stack:set container -a your-app-name

# (Optional but recommended) Set up basic authentication
heroku config:set BASIC_AUTH_USER=youruser -a your-app-name
heroku config:set BASIC_AUTH_PASSWORD=yourpassword -a your-app-name

# Add PostgreSQL and Redis addons
heroku addons:create heroku-postgresql:mini -a your-app-name
heroku addons:create heroku-redis:mini -a your-app-name

# Deploy the app
git push heroku main

# Open the app in your browser
heroku open -a your-app-name
```

## Sharing Access with Friends

### Option 1: Basic Authentication (Recommended)

When you set `BASIC_AUTH_USER` and `BASIC_AUTH_PASSWORD` during deployment, your friends will need to enter these credentials when accessing the site. Simply share the credentials with the friends you want to give access to:

- **URL**: `https://your-app-name.herokuapp.com`
- **Username**: The value you set for `BASIC_AUTH_USER`
- **Password**: The value you set for `BASIC_AUTH_PASSWORD`

### Option 2: AzuraCast Built-in Users

AzuraCast has its own user management system. After deployment:

1. Log in to the admin account (first-time setup wizard)
2. Navigate to System Administration → Users
3. Create accounts for your friends
4. Share the login credentials with them

## Configuration

### Environment Variables

You can customize your deployment using these environment variables:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `BASIC_AUTH_USER` | Username for basic HTTP authentication | - | No |
| `BASIC_AUTH_PASSWORD` | Password for basic HTTP authentication | - | No |
| `AZURACAST_HTTP_PORT` | HTTP port for AzuraCast | 8080 | Yes |
| `ENABLE_REDIS` | Enable Redis caching | true | Yes |
| `ENABLE_ADVANCED_FEATURES` | Enable advanced features | true | No |

### Updating Configuration

To update environment variables after deployment:

```bash
heroku config:set VARIABLE_NAME=value -a your-app-name
```

## Important Notes

### Free vs Paid Dynos

- **Free dynos** sleep after 30 minutes of inactivity, which may interrupt streaming
- For reliable 24/7 streaming, consider using **Hobby** or **Standard** dynos
- Upgrade with: `heroku dyno:type standard-2x -a your-app-name`

### Storage Limitations

- Heroku's ephemeral filesystem means uploaded media files will be lost on dyno restart
- For persistent storage, consider:
  - Using AzuraCast's remote storage features (S3, etc.)
  - Connecting to external storage services
  - Using Heroku's storage addons

### Resource Requirements

AzuraCast is resource-intensive. Recommended minimum:
- **Dyno Type**: Standard-2X (1GB RAM)
- **PostgreSQL**: Mini or higher
- **Redis**: Mini or higher

## Troubleshooting

### App won't start

Check the logs:
```bash
heroku logs --tail -a your-app-name
```

### Can't access the site

1. Verify the app is running: `heroku ps -a your-app-name`
2. Check if basic auth credentials are correct
3. Ensure the dyno type is sufficient (Standard-2X recommended)

### Database connection issues

Verify addons are provisioned:
```bash
heroku addons -a your-app-name
```

## Support

- **AzuraCast Documentation**: https://docs.azuracast.com/
- **AzuraCast GitHub**: https://github.com/AzuraCast/AzuraCast
- **Heroku Documentation**: https://devcenter.heroku.com/

## License

This deployment configuration is provided as-is. AzuraCast is licensed under the Apache License 2.0.
