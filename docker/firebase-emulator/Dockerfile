FROM node:22-alpine

RUN npm install -g firebase-tools@13.29.1

WORKDIR /firebase

COPY firebase.json .
COPY .firebaserc .

EXPOSE 4000 9099 8080 9199

# Auth emulator only until Firebase project is created (BP1.2 policy)
CMD ["firebase", "emulators:start", "--only", "auth", "--project", "glylens-dev", "--import=/firebase/data", "--export-on-exit"]
