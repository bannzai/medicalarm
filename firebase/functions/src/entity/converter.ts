import * as admin from "firebase-admin";
import { z } from "zod";

export function firestoreConverter<T extends z.AnyZodObject>(
  schema: T
): admin.firestore.FirestoreDataConverter<z.infer<T>> {
  return {
    toFirestore: (data: z.infer<T>): admin.firestore.DocumentData => {
      return schema.parse(data);
    },
    fromFirestore: (
      snapshot: admin.firestore.QueryDocumentSnapshot<z.infer<T>>
    ): z.infer<T> => {
      return schema.parse(snapshot.data());
    },
  };
}
