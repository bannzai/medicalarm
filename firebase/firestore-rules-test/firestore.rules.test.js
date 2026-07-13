const fs = require('fs');
const path = require('path');
const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');
const { doc, getDoc, setDoc, deleteDoc } = require('firebase/firestore');

// demo- 接頭辞により Emulator が demo モード (実プロジェクト不要) で動作する。
// package.json の `firebase emulators:exec --project demo-medicalarm` と一致させる。
const PROJECT_ID = 'demo-medicalarm';
const RULES_PATH = path.resolve(__dirname, '..', 'firestore.rules');

// emulators:exec が子プロセスに設定する FIRESTORE_EMULATOR_HOST ("host:port") から接続先を得る。
const [EMULATOR_HOST, EMULATOR_PORT] = (process.env.FIRESTORE_EMULATOR_HOST ?? '127.0.0.1:8080').split(':');

// グループ g1 のメンバー。alice / bob がメンバー、charlie は非メンバー。
const GROUP_ID = 'g1';
const MEMBER_IDS = ['alice', 'bob'];

// グループ配下の全サブコレクション (非メンバーは read/write とも不可であること)。
const GROUP_SUBCOLLECTIONS = [
  'userProfiles',
  'medicines',
  'doseReceivers',
  'medicationHistories',
  'diaries',
  'memberNotificationSettings',
];

// 全メンバーが自由に read/write できる共有サブコレクション (本人性チェック無し)。
const FREE_WRITE_SUBCOLLECTIONS = ['medicines', 'medicationHistories', 'diaries'];

let testEnv;

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: fs.readFileSync(RULES_PATH, 'utf8'),
      host: EMULATOR_HOST,
      port: Number(EMULATOR_PORT),
    },
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

// 各テストごとにデータをクリアし、rules を無効化した状態でグループ本体を seed する。
// (isMember / isGroupMember は groups/{id} の memberUserIDs を参照するため本体が必須)
beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), `groups/${GROUP_ID}`), {
      id: GROUP_ID,
      memberUserIDs: MEMBER_IDS,
      name: 'テストグループ',
    });
  });
});

describe('groups: メンバーは本体を read/update でき、共有サブコレクションを read/write できる', () => {
  test('メンバー(alice)は groups/{id} 本体を read/update できる', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(getDoc(doc(db, `groups/${GROUP_ID}`)));
    await assertSucceeds(
      setDoc(doc(db, `groups/${GROUP_ID}`), { memberUserIDs: MEMBER_IDS, name: '更新後' }, { merge: true }),
    );
  });

  // グループ削除フローはクライアントに無いため、メンバーでも delete は拒否される。
  test('メンバー(alice)でも groups/{id} 本体の delete は拒否される', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertFails(deleteDoc(doc(db, `groups/${GROUP_ID}`)));
  });

  test.each(FREE_WRITE_SUBCOLLECTIONS)('メンバー(alice)は groups/{id}/%s を read/write できる', async (subCollection) => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(setDoc(doc(db, `groups/${GROUP_ID}/${subCollection}/x`), { foo: 'bar' }));
    await assertSucceeds(getDoc(doc(db, `groups/${GROUP_ID}/${subCollection}/x`)));
  });
});

describe('groups/doseReceivers: メンバーは read/create/update できるが delete は不可', () => {
  test('メンバー(alice)は doseReceivers を read/create/update できるが delete は拒否される', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(setDoc(doc(db, `groups/${GROUP_ID}/doseReceivers/r1`), { name: '本人' }));
    await assertSucceeds(getDoc(doc(db, `groups/${GROUP_ID}/doseReceivers/r1`)));
    await assertSucceeds(setDoc(doc(db, `groups/${GROUP_ID}/doseReceivers/r1`), { name: '更新後' }, { merge: true }));
    // DoseReceiver は削除不可の設計をグループ側でも維持する。
    await assertFails(deleteDoc(doc(db, `groups/${GROUP_ID}/doseReceivers/r1`)));
  });
});

describe('groups/userProfiles: read はメンバー全員、write は自分の profile のみ', () => {
  test('メンバー(alice)は自分の userProfile を create/update できる', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(setDoc(doc(db, `groups/${GROUP_ID}/userProfiles/p_alice`), { userID: 'alice', displayName: 'Alice' }));
    await assertSucceeds(
      setDoc(doc(db, `groups/${GROUP_ID}/userProfiles/p_alice`), { userID: 'alice', displayName: '更新後' }, { merge: true }),
    );
  });

  test('メンバー(alice)は他人(bob)の userProfile を read できるが write はできない', async () => {
    // bob の profile を rules 無効で seed する。
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), `groups/${GROUP_ID}/userProfiles/p_bob`), { userID: 'bob', displayName: 'Bob' });
    });
    const db = testEnv.authenticatedContext('alice').firestore();
    // read はメンバーなら他人分も可。
    await assertSucceeds(getDoc(doc(db, `groups/${GROUP_ID}/userProfiles/p_bob`)));
    // 他人の profile への update は拒否。
    await assertFails(
      setDoc(doc(db, `groups/${GROUP_ID}/userProfiles/p_bob`), { userID: 'bob', displayName: 'Hacked' }, { merge: true }),
    );
    // userID を他人にした create も拒否。
    await assertFails(setDoc(doc(db, `groups/${GROUP_ID}/userProfiles/p_new`), { userID: 'bob', displayName: 'Hacked' }));
  });
});

describe('groups/memberNotificationSettings: read はメンバー全員、write は本人 docID のみ', () => {
  test('メンバー(alice)は自分の docID を read/write でき、他人(bob)の docID には write できない', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    // docID = 自分の uid なら write 可。
    await assertSucceeds(setDoc(doc(db, `groups/${GROUP_ID}/memberNotificationSettings/alice`), { useCriticalAlert: true }));
    await assertSucceeds(getDoc(doc(db, `groups/${GROUP_ID}/memberNotificationSettings/alice`)));
    // docID = 他人の uid への write は拒否。
    await assertFails(setDoc(doc(db, `groups/${GROUP_ID}/memberNotificationSettings/bob`), { useCriticalAlert: false }));
  });

  test('メンバー(alice)は他人(bob)の memberNotificationSettings を read できる', async () => {
    // bob の設定を rules 無効で seed する。
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), `groups/${GROUP_ID}/memberNotificationSettings/bob`), { useCriticalAlert: true });
    });
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(getDoc(doc(db, `groups/${GROUP_ID}/memberNotificationSettings/bob`)));
  });
});

describe('groups: 非メンバー・未認証は read/write とも拒否される', () => {
  test('非メンバー(charlie)は groups/{id} 本体を read/write できない', async () => {
    const db = testEnv.authenticatedContext('charlie').firestore();
    await assertFails(getDoc(doc(db, `groups/${GROUP_ID}`)));
    await assertFails(
      setDoc(doc(db, `groups/${GROUP_ID}`), { memberUserIDs: MEMBER_IDS }, { merge: true }),
    );
  });

  test.each(GROUP_SUBCOLLECTIONS)('非メンバー(charlie)は groups/{id}/%s を read/write できない', async (subCollection) => {
    const db = testEnv.authenticatedContext('charlie').firestore();
    await assertFails(getDoc(doc(db, `groups/${GROUP_ID}/${subCollection}/x`)));
    await assertFails(setDoc(doc(db, `groups/${GROUP_ID}/${subCollection}/x`), { foo: 'bar' }));
  });

  test('未認証は groups/{id} を read/write できない', async () => {
    const db = testEnv.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, `groups/${GROUP_ID}`)));
    await assertFails(getDoc(doc(db, `groups/${GROUP_ID}/medicines/x`)));
  });
});

describe('groups create / groupInvitations: クライアント直アクセスは全面拒否', () => {
  test('クライアントからの groups 作成は拒否される', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertFails(setDoc(doc(db, 'groups/newGroup'), { memberUserIDs: ['alice'] }));
  });

  test('groupInvitations は read も write も拒否される', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertFails(getDoc(doc(db, 'groupInvitations/i1')));
    await assertFails(setDoc(doc(db, 'groupInvitations/i1'), { groupID: GROUP_ID }));
  });
});

describe('users ツリー: 本人のみアクセス可能 (旧本番ルールの操作別許可を維持)', () => {
  test('本人(alice)は users/alice を read/write でき、privates は書き込みのみできる', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(setDoc(doc(db, 'users/alice'), { name: 'Alice' }));
    await assertSucceeds(getDoc(doc(db, 'users/alice')));
    await assertSucceeds(setDoc(doc(db, 'users/alice/privates/alice'), { fcmToken: 't' }));
    // 旧本番ルールどおり privates の read は本人でも不可 (クライアントは書き込みのみ)。
    await assertFails(getDoc(doc(db, 'users/alice/privates/alice')));
    // 旧本番ルールどおり users 本体の delete は不可。
    await assertFails(deleteDoc(doc(db, 'users/alice')));
  });

  test('他人(bob)は users/alice を read/write できない', async () => {
    const db = testEnv.authenticatedContext('bob').firestore();
    await assertFails(getDoc(doc(db, 'users/alice')));
    await assertFails(setDoc(doc(db, 'users/alice'), { name: 'Hacked' }));
    await assertFails(getDoc(doc(db, 'users/alice/privates/alice')));
  });

  test('レガシー /users/alice/medicines 等は本人のみアクセス可能', async () => {
    const aliceDB = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(setDoc(doc(aliceDB, 'users/alice/medicines/m1'), { name: '薬' }));
    await assertSucceeds(getDoc(doc(aliceDB, 'users/alice/medicines/m1')));
    await assertSucceeds(setDoc(doc(aliceDB, 'users/alice/medicationHistories/h1'), { at: 1 }));
    // diaries はグループ移行 (GroupMigration) が読むため #241 で match を追加した。
    await assertSucceeds(setDoc(doc(aliceDB, 'users/alice/diaries/d1'), { memo: '日記' }));
    await assertSucceeds(getDoc(doc(aliceDB, 'users/alice/diaries/d1')));
    // 旧本番ルールどおり doseReceivers の delete は不可 (DoseReceiver は削除不可の設計)。
    await assertSucceeds(setDoc(doc(aliceDB, 'users/alice/doseReceivers/r1'), { name: '本人' }));
    await assertFails(deleteDoc(doc(aliceDB, 'users/alice/doseReceivers/r1')));

    const bobDB = testEnv.authenticatedContext('bob').firestore();
    await assertFails(getDoc(doc(bobDB, 'users/alice/medicines/m1')));
    await assertFails(setDoc(doc(bobDB, 'users/alice/medicines/m1'), { name: 'Hacked' }));
  });
});

describe('デバッグユーザーパターン: {uid}_debug_[0-9]+', () => {
  test('uid=alice は users/alice_debug_1 を read/write できる', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertSucceeds(setDoc(doc(db, 'users/alice_debug_1'), { name: 'AliceDebug' }));
    await assertSucceeds(getDoc(doc(db, 'users/alice_debug_1')));
    // レガシーサブコレクションもデバッグユーザー配下でアクセスできる。
    await assertSucceeds(setDoc(doc(db, 'users/alice_debug_1/medicines/m1'), { name: '薬' }));
  });

  test('uid=alice は users/bob_debug_1 を read/write できない', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();
    await assertFails(getDoc(doc(db, 'users/bob_debug_1')));
    await assertFails(setDoc(doc(db, 'users/bob_debug_1'), { name: 'Hacked' }));
  });
});
