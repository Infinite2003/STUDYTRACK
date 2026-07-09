const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendTaskReminder = functions.pubsub.schedule("every 1 hours").onRun(async () => {
  const now = new Date();
  const tasksSnapshot = await admin.firestore().collection("tasks").get();

  for (const doc of tasksSnapshot.docs) {
    const task = doc.data();
    const dueDate = new Date(task.dueDate);
    const reminderTime = new Date(dueDate.getTime() - task.reminderHours * 3600000);

    if (reminderTime <= now && !task.completed) {
      const tokensSnapshot = await admin.firestore()
        .collection("userTokens")
        .doc(task.userId)
        .collection("tokens")
        .get();

      const tokens = tokensSnapshot.docs.map(d => d.id);
      if (tokens.length > 0) {
        await admin.messaging().sendMulticast({
          tokens,
          notification: {
            title: "Recordatorio de tarea",
            body: `Tu tarea "${task.title}" vence pronto.`,
          },
        });
      }
    }
  }
});
