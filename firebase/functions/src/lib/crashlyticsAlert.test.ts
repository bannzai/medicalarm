// crashlyticsAlert のユニットテスト。投稿先がプロジェクトを問わず本番の通知チャンネルであることと、プロジェクト ID の解決を確かめる。
import { CRASHLYTICS_SLACK_CHANNEL, currentProjectId } from "./crashlyticsAlert";

describe("CRASHLYTICS_SLACK_CHANNEL", () => {
  it("#medicalarm-notification を指す", () => {
    expect(CRASHLYTICS_SLACK_CHANNEL).toBe("#medicalarm-notification");
  });
});

describe("currentProjectId", () => {
  const originalGcloudProject = process.env.GCLOUD_PROJECT;
  const originalFirebaseConfig = process.env.FIREBASE_CONFIG;

  beforeEach(() => {
    delete process.env.GCLOUD_PROJECT;
    delete process.env.FIREBASE_CONFIG;
  });

  afterEach(() => {
    if (originalGcloudProject === undefined) {
      delete process.env.GCLOUD_PROJECT;
    } else {
      process.env.GCLOUD_PROJECT = originalGcloudProject;
    }
    if (originalFirebaseConfig === undefined) {
      delete process.env.FIREBASE_CONFIG;
    } else {
      process.env.FIREBASE_CONFIG = originalFirebaseConfig;
    }
  });

  it("環境変数が無ければ unknown-project を返す", () => {
    expect(currentProjectId()).toBe("unknown-project");
  });

  it("GCLOUD_PROJECT を優先する", () => {
    process.env.GCLOUD_PROJECT = "medicalarm-dev";
    process.env.FIREBASE_CONFIG = JSON.stringify({ projectId: "medicalarm-prod" });
    expect(currentProjectId()).toBe("medicalarm-dev");
  });

  it("GCLOUD_PROJECT が無ければ FIREBASE_CONFIG の projectId を返す", () => {
    process.env.FIREBASE_CONFIG = JSON.stringify({ projectId: "medicalarm-prod" });
    expect(currentProjectId()).toBe("medicalarm-prod");
  });
});
