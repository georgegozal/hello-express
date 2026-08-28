# hello-express

Tiny Express sample app (`/`, `/health`, `/version`) used as one of the two
apps in the [cicd-lab](https://github.com/georgegozal/cicd-lab) CI/CD
learning pipeline. On every push to `main`, `.github/workflows/build-and-push.yml`
builds this Dockerfile, pushes to `ghcr.io/georgegozal/hello-express`, and
notifies a deploy-agent webhook to redeploy it.

Run locally:
```bash
npm install
npm start
```

Run in Docker:
```bash
docker build --build-arg APP_VERSION=manual-test -t hello-express:test .
docker run --rm -p 3000:3000 hello-express:test
```
