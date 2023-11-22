import * as firestore from "@google-cloud/firestore";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as logger from "firebase-functions/logger";

admin.initializeApp();

export const makeAdminIfWhitelisted = functions.auth.user().onCreate(async (user, _) => {
  const email = user.email;
  let isAdmin = true;

  if (email === undefined) {
    logger.log(`User ${user.uid} does not have an email`);
    isAdmin = false;
    return;
  }

  // if(!user.emailVerified) {
  //   logger.log(`${email} is not verified`);
  //   isAdmin = false;
  //   return;
  // }

  if (!email.endsWith("@admin.com")) {
    logger.log(`${email} is not an admin`);
    isAdmin = false;
    return;
  }

  if (user.customClaims?.admin === true) {
    logger.log(`${email} is already an admin`);
    isAdmin = false;
    return;
  }

  await admin.auth().setCustomUserClaims(user.uid, { admin: isAdmin });
  await admin.firestore().doc(`metadata/${user.uid}`).set({ refreshTime: firestore.FieldValue.serverTimestamp() })
  logger.log(`Custom claim set for ${email}`);
});
