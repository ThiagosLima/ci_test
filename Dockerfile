# Multistage docker for 4 environments
# 1) Base environment
FROM node:12.10.0-alpine as base
COPY package*.json ./

# 2) Development environment
FROM base as dev
ENV NODE_ENV=development
RUN npm install
COPY . .
CMD [ "../node_modules/nodemon/bin/nodemon.js", "index.js" ]

# 3) Test environment
FROM dev as test
ENV NODE_ENV=development
CMD ["npm", "test"]

# Optimized installation for production
# 4) Production environment
FROM base as prod
ENV NODE_ENV=production
RUN npm install --only=production \
  && npm cache clean --force
COPY . .
CMD ["node", "index.js"]