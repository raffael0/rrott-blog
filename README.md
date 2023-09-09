# RRott-blog
This is the GitHub home for my blog blog.rrott.eu.



## Development
### Install dependencies
```shell
yarn install
```
### Run Dev server
```shell
yarn dev
```

## Deploying
I've created a Dockerfile to deploy the application. To build the image run:
```shell
docker build . -t rrott-blog
```
Then run the container
```shell
docker run -p 3000:3000 rrott-blog
```
## Credits
I've used the [Tailwind Nextjs Starter Blog template](https://github.com/timlrx/tailwind-nextjs-starter-blog) as a starting point for my blog.