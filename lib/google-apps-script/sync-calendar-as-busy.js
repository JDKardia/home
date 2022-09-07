/**
 * Syncs your personal calendar with your work calendar as 'busy' events.
 */

// WARNING: This script has the potential to delete events! Audit the code and run with care.
// The script *should* only delete events it has previously created, but bugs are possible!

// How to use
// ==========
// 1. Share your personal calendar with your work account using the free/busy option.
// 2. Visit https://script.google.com/ and create a new project eg. "Personal calendar sync".
// 3. Uncomment, fill in, and run the line below.
// 4. Set up a scheduled trigger to run the `syncEvents` script every hour.

// Debugging tip:
// 1. Visit https://www.google.com/calendar/render?gsessionid=OK&eventdeb=1
// 2. Click into an event.
// 3. More Actions > Troubleshooting Info
// 4. Observe the event ID and other information.
// (Does not show tags :()

PropertiesService.getUserProperties().setProperties({
	PERSONAL_EMAIL: 'EMAILTOSYNC@SOMEPLACE.COM',
	DAYS_TO_SYNC: '21'
})


const daysToSyncPropertyValue = PropertiesService.getUserProperties().getProperty('DAYS_TO_SYNC')
const DAYS_TO_SYNC = daysToSyncPropertyValue ? Number.parseInt(daysToSyncPropertyValue, 10) : 7;

function isWeekend(someDate) {
	return someDate.getDay() < 1 || someDate.getDay() > 5;
}

function getEventId(event) {
	// Beware the semantics of event.getId() for recurring events! The ID returned
	// by getId() is the id of the recurrence, not a unique ID for the event!
	// https://developers.google.com/apps-script/reference/calendar/calendar-event#getid
	//
	// Also, if we only share free/busy information then `event.isRecurringEvent()` always returns false >__>
	// Hack: Always append event start time to the ID.
	return `${event.getId()}:${event.getStartTime().toISOString()}`;
}

function syncEvents() {
	const personalEmail = PropertiesService.getUserProperties().getProperty('PERSONAL_EMAIL');
	if (personalEmail == null) {
		console.error('No PERSONAL_EMAIL user property set. Save a property in https://developers.google.com/apps-script/reference/properties/properties-service#getUserProperties().')
		return;
	}

	const personalCalendar = CalendarApp.getCalendarById(personalEmail);
	const workCalendar = CalendarApp.getDefaultCalendar();

	const now = new Date();
	const futureDate = new Date(
		now.getTime() + DAYS_TO_SYNC * 86400 /* seconds in a day */ * 1000 /* milliseconds in a second */);
	const eventsToSync = personalCalendar.getEvents(now, futureDate)
		.filter(event => !event.isAllDayEvent())
		.filter(event => !isWeekend(event.getStartTime()));

	let workEvents = workCalendar.getEvents(now, futureDate);
	workEvents = workEvents.filter(workEvent => workEvent.getTag('source') === 'personal-calendar-sync');

	const workEventsBySourceId = Object.fromEntries(workEvents.map(workEvent => {
		let sourceId = workEvent.getTag('source_id');
		if (sourceId == null) {
			console.log('problem event:')
			console.log('\tworkevent title:', workEvent.getTitle())
			console.log('\tworkevent summary:', workEvent.getSummary())
			console.log('\tworkevent start time:', workEvent.getStartTime())
		}
		if (sourceId.endsWith('@google.com')) {
			sourceId = `${sourceId}:${workEvent.getStartTime().toISOString()}`
		}
		return [sourceId, workEvent];
	}));

	let eventsAdded = 0;
	let eventsChanged = 0;
	let eventsDeleted = 0;

	for (let eventToSync of eventsToSync) {
		const sourceId = getEventId(eventToSync);
		if (workEventsBySourceId.hasOwnProperty(sourceId)) {
			const correspondingWorkEvent = workEventsBySourceId[sourceId];
			delete workEventsBySourceId[sourceId]
			if (correspondingWorkEvent.getStartTime() === eventToSync.getStartTime() &&
				correspondingWorkEvent.getEndTime() === eventToSync.getEndTime()) {
				continue;
			}
			correspondingWorkEvent.setTime(eventToSync.getStartTime(), eventToSync.getEndTime());
			eventsChanged += 1;
		} else {
			const newEvent = workCalendar.createEvent('busy', eventToSync.getStartTime(), eventToSync.getEndTime());
			newEvent.setTag('source', 'personal-calendar-sync');
			newEvent.setTag('source_id', sourceId);
			eventsAdded += 1;
		}
	}

	const remainingEventsToDelete = Object.values(workEventsBySourceId);
	remainingEventsToDelete.forEach(remainingEventToDelete => {
		// Switch to this line for testing to prevent deleting events
		// remainingEventToDelete.setColor(CalendarApp.EventColor.RED);
		remainingEventToDelete.deleteEvent();
		eventsDeleted += 1
	});

	console.log(`${eventsAdded} events added, ${eventsChanged} events changed, ${eventsDeleted} deleted.`)
}
