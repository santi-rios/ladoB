# Deployment Guide

This guide provides detailed information about deploying and managing your AzuraCast instance on Heroku.

## Prerequisites

- A Heroku account (free tier is fine to start)
- Basic understanding of web applications and Docker
- Git (for manual deployment)

## Quick Start

### Option 1: One-Click Deploy (Recommended)

1. Click the "Deploy to Heroku" button in the README
2. Fill in your app name
3. **Important:** Set `BASIC_AUTH_USER` and `BASIC_AUTH_PASSWORD` to restrict access
4. Click "Deploy app"
5. Wait 5-10 minutes for deployment to complete

### Option 2: Manual Deploy via Heroku CLI

```bash
# Install Heroku CLI if you haven't already
# Visit: https://devcenter.heroku.com/articles/heroku-cli

# Clone this repository
git clone https://github.com/santi-rios/ladoB.git
cd ladoB

# Login to Heroku
heroku login

# Create a new Heroku app
heroku create my-radio-station

# Set the stack to container (required for Docker deployment)
heroku stack:set container

# Configure basic authentication (recommended)
heroku config:set BASIC_AUTH_USER=your_username
heroku config:set BASIC_AUTH_PASSWORD=your_secure_password

# Add PostgreSQL database
heroku addons:create heroku-postgresql:mini

# Add Redis cache
heroku addons:create heroku-redis:mini

# Deploy to Heroku
git push heroku main

# Open your app
heroku open
```

## Security Considerations

### Basic Authentication

The `BASIC_AUTH_USER` and `BASIC_AUTH_PASSWORD` environment variables provide a simple layer of authentication:

**Pros:**
- Easy to set up
- Works immediately
- No additional configuration needed
- Good for sharing with trusted friends

**Cons:**
- Not as secure as OAuth or other modern authentication methods
- Credentials are shared among all users
- No per-user permissions

**Best Practices:**
- Always use HTTPS (Heroku provides this automatically)
- Use a strong password (minimum 12 characters, mix of letters, numbers, symbols)
- Change passwords periodically
- Consider using AzuraCast's built-in user management for better control

### AzuraCast User Management

For more granular access control:

1. Deploy without basic auth or disable it later
2. Complete the initial AzuraCast setup
3. Create individual user accounts in AzuraCast
4. Assign appropriate permissions to each user
5. Share individual credentials with your friends

## Sharing with Friends

### Method 1: Single Shared Credential (Basic Auth)

Share these with your friends:
- URL: `https://your-app-name.herokuapp.com`
- Username: Your `BASIC_AUTH_USER` value
- Password: Your `BASIC_AUTH_PASSWORD` value

### Method 2: Individual Accounts (Recommended)

1. Set up your AzuraCast instance
2. Navigate to Administration → Users
3. Create accounts for each friend
4. Assign appropriate roles (DJ, Station Manager, etc.)
5. Share individual credentials

## Heroku Dyno Tiers

### Free Tier Limitations
- **Sleep after inactivity**: Apps sleep after 30 minutes of no web traffic
- **Monthly hours**: Limited to 550 hours/month (can be increased to 1000 with credit card)
- **Not suitable for**: 24/7 radio streaming

### Hobby Tier ($7/month per dyno)
- **No sleeping**: Apps never sleep
- **Better for**: Personal radio stations
- **Suitable for**: Streaming to small groups of friends

### Standard Tier ($25-$500/month)
- **Better performance**: More CPU and memory
- **Recommended for**: Production radio stations
- **Suitable for**: Larger audiences

Upgrade command:
```bash
heroku dyno:type hobby -a your-app-name
# or
heroku dyno:type standard-1x -a your-app-name
```

## Resource Management

### Monitoring

View logs:
```bash
heroku logs --tail -a your-app-name
```

Check dyno status:
```bash
heroku ps -a your-app-name
```

View metrics:
```bash
heroku metrics -a your-app-name
```

### Database Management

View database info:
```bash
heroku pg:info -a your-app-name
```

Access database:
```bash
heroku pg:psql -a your-app-name
```

### Scaling

Scale up:
```bash
heroku ps:scale web=1:standard-2x -a your-app-name
```

## Troubleshooting

### App Won't Start

1. Check logs: `heroku logs --tail -a your-app-name`
2. Verify addons are created: `heroku addons -a your-app-name`
3. Check environment variables: `heroku config -a your-app-name`
4. Ensure you're using container stack: `heroku stack -a your-app-name`

### Can't Access the Site

1. Verify app is running: `heroku ps -a your-app-name`
2. Check if basic auth credentials are correct
3. Try accessing without credentials to see error message
4. Check Heroku status: https://status.heroku.com/

### Streaming Issues

1. Verify dyno is not sleeping (upgrade to Hobby or higher)
2. Check logs for errors during streaming
3. Ensure enough resources (Standard-2X recommended minimum)
4. Verify radio station is properly configured in AzuraCast

### Database Connection Issues

1. Verify PostgreSQL addon is provisioned
2. Check DATABASE_URL is set: `heroku config:get DATABASE_URL -a your-app-name`
3. Review startup logs for database connection errors

## Customization

### Custom Domain

Add a custom domain:
```bash
heroku domains:add www.yourradio.com -a your-app-name
```

Then configure your DNS provider to point to the Heroku DNS target.

### Environment Variables

View all config:
```bash
heroku config -a your-app-name
```

Set a variable:
```bash
heroku config:set VARIABLE_NAME=value -a your-app-name
```

Remove a variable:
```bash
heroku config:unset VARIABLE_NAME -a your-app-name
```

## Backup and Restore

### Backup Database

Create a backup:
```bash
heroku pg:backups:capture -a your-app-name
```

Download a backup:
```bash
heroku pg:backups:download -a your-app-name
```

### Restore Database

```bash
heroku pg:backups:restore [BACKUP_ID] DATABASE_URL -a your-app-name
```

## Cost Estimation

**Minimal Setup (Testing):**
- Heroku Dyno: Free or Hobby ($7/month)
- PostgreSQL: Free or Mini ($9/month)
- Redis: Free or Mini ($3/month)
- **Total**: $0-19/month

**Recommended Setup (Friends):**
- Heroku Dyno: Standard-2X ($50/month)
- PostgreSQL: Mini ($9/month)
- Redis: Mini ($3/month)
- **Total**: ~$62/month

**Production Setup:**
- Heroku Dyno: Standard or Performance
- PostgreSQL: Standard or higher
- Redis: Premium or higher
- **Total**: $100+/month

## Additional Resources

- [Heroku Container Registry & Runtime](https://devcenter.heroku.com/articles/container-registry-and-runtime)
- [AzuraCast Documentation](https://docs.azuracast.com/)
- [Heroku Pricing](https://www.heroku.com/pricing)
- [PostgreSQL on Heroku](https://devcenter.heroku.com/articles/heroku-postgresql)
- [Redis on Heroku](https://devcenter.heroku.com/articles/heroku-redis)
