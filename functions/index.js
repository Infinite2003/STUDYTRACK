const { onSchedule } = require("firebase-functions/v2/scheduler");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

async function getTokensForUser(uid) {
  const tokensSnapshot = await admin.firestore()
    .collection("userTokens")
    .doc(uid)
    .collection("tokens")
    .get();
  return tokensSnapshot.docs.map((d) => d.id);
}

exports.sendTaskReminder = onSchedule("every 1 hours", async (event) => {
  const now = new Date();

  const tasksSnapshot = await admin.firestore()
    .collection("tasks")
    .where("completed", "==", false)
    .where("reminderSent", "==", false)
    .get();

  if (tasksSnapshot.empty) {
    logger.info("No hay tareas pendientes de notificar.");
    return;
  }

  const batch = admin.firestore().batch();

  for (const doc of tasksSnapshot.docs) {
    const task = doc.data();
    const dueDate = new Date(task.dueDate); // string ISO
    const reminderTime = new Date(dueDate.getTime() - task.reminderHours * 3600000);

    if (reminderTime <= now) {
      const memberUids = task.members || [task.userId];

      const tokensPerMember = await Promise.all(
        memberUids.map((uid) => getTokensForUser(uid))
      );
      const tokens = tokensPerMember.flat();

      if (tokens.length > 0) {
        try {
          await admin.messaging().sendEachForMulticast({
            tokens,
            notification: {
              title: "Recordatorio de tarea",
              body: `La tarea "${task.title}" vence pronto.`,
            },
            data: { taskId: doc.id },
          });
          batch.update(doc.ref, { reminderSent: true });
        } catch (err) {
          logger.error(`Error enviando notificación para tarea ${doc.id}:`, err);
        }
      } else {
        logger.warn(`Sin tokens FCM para tarea ${doc.id} (miembros: ${memberUids.join(", ")})`);
      }
    }
  }

  await batch.commit();
});