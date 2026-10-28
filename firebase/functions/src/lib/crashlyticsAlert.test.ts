// crashlyticsSlackChannel のユニットテスト。本番のプロジェクトだけ本番の通知チャンネルに投稿し、それ以外は -qa に倒すことを確かめる。
import { crashlyticsSlackChannel, currentProjectId } from "./crashlyticsAlert";

describe("crashlyticsSlackChannel", () => {
  it("本番のプロジェクト ID では #medicalarm-notification を返す", () => {
    expect(crashlyticsSlackChannel("medicalarm-prod")).toBe("#medicalarm-notification");
  });

  it("別のプロジェクト ID では #medicalarm-notification-qa を返す", () => {
    expect(crashlyticsSlackChannel("medicalarm-dev")).toBe("#medicalarm-notification-qa");
  });

  it("空文字では #medicalarm-notification-qa を返す", () => {
    expect(crashlyticsSlackChannel("")).toBe("#medicalarm-notification-qa");
  });

  describe("プロジェクト ID の環境変数が無い時", () => {
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

    it("#medicalarm-notification-qa を返す", () => {
      expect(crashlyticsSlackChannel(currentProjectId())).toBe("#medicalarm-notification-qa");
    });

    it("FIREBASE_CONFIG の projectId が本番なら #medicalarm-notification を返す", () => {
      process.env.FIREBASE_CONFIG = JSON.stringify({ projectId: "medicalarm-prod" });
      expect(crashlyticsSlackChannel(currentProjectId())).toBe("#medicalarm-notification");
    });
  });
});
