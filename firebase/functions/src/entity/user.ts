import { z } from "zod";
import { FirestoreTimestampSchema } from "./timestamp";

export const AppUserSchema = z.object({
  startPromotionDateTime: FirestoreTimestampSchema.nullish(),
  maybeTrialDeadlineDate: FirestoreTimestampSchema.nullish(),
  appliedShareRewardPremiumTrialCount: z.number().nullish(),
  pushToStartToken: z.string().nullish(),
});

export type AppUser = z.infer<typeof AppUserSchema>;
