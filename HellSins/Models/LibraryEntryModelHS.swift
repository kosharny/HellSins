import Foundation

struct LibraryEntryHS: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var feeling: String
    var content: String
    var isFavorite: Bool = false
    var imageName: String = ""

    static let library: [LibraryEntryHS] = [
        LibraryEntryHS(
            title: "The 90-Second Anger Rule",
            feeling: "angry",
            content: """
Neuroscientist Jill Bolte Taylor discovered something counterintuitive: the physiological lifespan of any emotion — including rage — is only 90 seconds. After the initial neurological surge, what keeps anger alive is you actively re-triggering it through thought loops.

When anger rises, the amygdala fires and floods the bloodstream with adrenaline and cortisol. Your heart rate accelerates, your vision narrows, your fists clench. This is biology. You didn't choose it. But after 90 seconds, if you stop feeding the thoughts, the chemistry literally dissipates.

What keeps anger burning beyond 90 seconds is the story you replay. "He disrespected me." "She always does this." "I never get what I deserve." Each replay re-triggers the amygdala surge. So the anger isn't just lasting — it's being constantly re-created by your narrative engine.

HOW TO APPLY THIS:
When anger rises, start an internal timer. Breathe into your belly — not your chest (chest breathing signals threat). Let 90 seconds pass without any self-talk, just observation of sensations. After the window passes, ask yourself: "Am I responding to what just happened, or to the story I'm now creating about it?"

The distinction matters enormously. The event is in the past. The story is happening now, in your mind, and you are its author.

WRATH TRAINING PROTOCOL:
→ Day 1-3: Notice when anger rises. Don't suppress. Just observe.
→ Day 4-7: Begin the 90-second count each time anger appears.
→ Day 8+: Practice choosing not to re-trigger after the window passes.

Advanced practitioners: move directly into box breathing (4-4-4-4) during the 90-second window.
""",
            imageName: "article_anger_90sec"
        ),
        LibraryEntryHS(
            title: "The Dopamine Loop of Social Media",
            feeling: "lazy",
            content: """
Every notification, like, share, or scroll triggers a micro-release of dopamine — the same neurotransmitter activated by gambling, drugs, and high-risk behavior. This is not accidental. It is engineered.

Silicon Valley product teams employed behavioral psychologists specifically to optimize for maximum dopamine engagement. Variable reward schedules — where you don't know if the next scroll will bring something interesting or not — are the most addictive mechanism in human psychology. It's the same principle that makes slot machines impossible to walk away from.

THE TOLERANCE TRAP:
As with any dopamine-triggering substance, your brain builds tolerance. What gave you a hit of pleasure a year ago now feels underwhelming. You need more content, faster, at higher emotional stakes just to feel the same baseline interest. This is why your attention span feels shorter and reading books feels harder — not because you've changed fundamentally, but because your dopamine baseline has shifted.

Meanwhile, real-world pleasures — a good meal, a walk, a conversation, the satisfaction of completing real work — generate quieter, subtler dopamine signals. Against the backdrop of your overstimulated reward system, they register as almost nothing. You feel nothing. You reach for your phone.

HOW TO RESET:
Research shows a 3-day phone-free period significantly drops baseline social media craving. You don't need to go forever — just enough to re-sensitize your reward circuit.

Start with scheduled windows. No phone for 20 minutes after waking. No phone 1 hour before sleep. Within a week most people report that food tastes better, music sounds richer, and conversations feel more rewarding.

You're not fighting technology. You're reclaiming your own dopamine system.
""",
            imageName: "article_dopamine_scroll"
        ),
        LibraryEntryHS(
            title: "Why You Keep Overspending",
            feeling: "greedy",
            content: """
The moment of purchase — not ownership, not use — is when dopamine fires. This is the neurological truth behind why your new purchase already feels less exciting 48 hours after arrival, but the next "perfect item" in your wishlist feels incredibly promising.

Retailers understand this mechanism with predatory precision:
— Scarcity signals ("Only 2 left!") trigger loss aversion, which is neurologically 2x stronger than pleasure.
— Flash sales override the prefrontal cortex's deliberation window by creating time pressure.
— BNPL (Buy Now Pay Later) schemes psychologically de-couple spending from loss, making it feel free.
— Recommended products after purchase exploit the still-activated dopamine circuit.

THE IMPULSE WINDOW:
Neuroscience shows your prefrontal cortex needs approximately 20-30 minutes to override an impulse-driven decision with rational evaluation. Marketers know this. Their entire infrastructure is designed to get you to purchase BEFORE you enter that window.

THE 24-HOUR RULE:
Clinical studies in behavioral economics show that implementing a mandatory 24-hour waiting period before any purchase over $20 reduces impulse spending by 47% without any sacrifice of genuine desired purchases. The items you still want after 24 hours — you actually want.

A more advanced version: write down what you're about to buy, what emotion triggered the desire, and what you hope it will make you feel. Read it the next morning. The answer is often illuminating.

GREED TRAINING PROTOCOL:
→ Create a "desire journal" — log every impulse purchase urge you have for one week.
→ Review the patterns. What emotion precedes each urge?
→ Install a 48-hour cart waiting list for anything over $50.
→ Spend 5 minutes daily reflecting on what you already own that brings genuine satisfaction.
""",
            imageName: "article_overspending"
        ),
        LibraryEntryHS(
            title: "Envy as a Mirror",
            feeling: "jealous",
            content: """
Envy is one of the most painful emotions humans experience — and one of the least understood. We're taught that envy is shameful, something to suppress and deny. But this suppression removes the very information the emotion is trying to deliver.

Envy, at its core, is the mind pointing at unlived potential. You envy what you unconsciously believe you could have or be, but feel blocked from reaching. You don't envy things randomly — you envy specifically what your deepest self recognizes as possible for you.

TWO TYPES OF ENVY:
Malicious envy: wanting what someone else has to be taken from them. This is corrosive and self-destructive.
Benign envy: wanting what someone else has for yourself. This type is a motivational signal if you choose to hear it.

The difference between them lies in whether you can tolerate the other person's success existing alongside your own desire.

THE MIRROR TECHNIQUE:
When you feel envy, instead of suppressing it, ask:
→ What specifically am I envying? (Be precise. Not "their life" — what aspect, exactly?)
→ Why do I believe I cannot have or create this?
→ Is that belief actually true? Or is it a story from my past?
→ If I had what they have — what would I do with it?

This process transforms envy from a wound into a map. The things that generate your most intense envy are often the clearest signal of where your unlived potential is concentrated.

ENVY TRAINING PROTOCOL:
Spend 3 days noticing every time envy appears. Write it down without judgment. By day 3, patterns will emerge that reveal your own deepest desires.
""",
            imageName: "article_envy_mirror"
        ),
        LibraryEntryHS(
            title: "The Procrastination-Shame Loop",
            feeling: "lazy",
            content: """
Procrastination is not laziness. Laziness is contentment with inaction. Procrastination is active avoidance driven by emotion. Specifically, people procrastinate tasks that trigger anxiety, self-doubt, boredom, resentment, or fear of failure.

The avoidance provides brief, immediate relief — you escape the discomfort of starting. But guilt accumulates. The unfinished task gains psychological weight. It appears in your mind uninvited, draining background cognitive resources. The task becomes MORE emotionally loaded the longer it waits — which makes it even harder to start. This is the shame spiral.

THE NEUROLOGICAL TRIGGER:
When you think about a task you're procrastinating on, the anterior insula — the brain region associated with physical pain — activates. Your brain is literally processing task-avoidance behavior the same way it processes physical threat. This is why starting feels impossible. Your biology has classified the task as dangerous.

THE FIX: SHRINK THE ENTRY POINT:
The brain's pain response is proportional to perceived magnitude. "Write the entire report" triggers massive avoidance. "Write the document title and first three words" triggers almost none.

The two-minute rule is clinically validated: if a task can be started with two minutes of action, begin immediately without negotiating. The act of beginning releases the amygdala's grip. Once started, momentum carries you.

ADVANCED TECHNIQUE — TIME BOXING:
Set a visible timer for 25 minutes. Commit to working ONLY until the timer ends. No goal, just time. After the timer, you have permission to stop. Most people don't stop — because now they're in flow. But even if they do stop, they've broken the avoidance pattern.

SLOTH TRAINING PROTOCOL:
→ Identify your "most avoided" task each morning.
→ Before anything else — before phone, before coffee — spend 2 minutes touching that task.
→ Two minutes only. Just start.
→ Track for 2 weeks. The task will progressively lose its emotional charge.
""",
            imageName: "article_procrastination"
        ),
        LibraryEntryHS(
            title: "Pride and the Feedback Wall",
            feeling: "proud",
            content: """
Excessive pride — distinct from healthy self-respect — activates the same defensive neural systems as physical threat. When the ego is challenged, the amygdala fires exactly as it does when your survival is threatened. This is why arrogant people literally cannot process criticism clearly: their biology has classified feedback as an attack.

The irony is devastating. The very defense mechanism designed to protect the self ensures the self will never grow. Arrogant people stop receiving accurate information about reality because every correction feels like violence.

INTELLECTUAL HUMILITY — THE RARE DISCIPLINE:
The highest performers across any field share one consistent trait researchers didn't expect: the ability to update their beliefs based on new information without emotional resistance.

Scientists call this "epistemic humility" — the genuine acknowledgment that your current understanding is probably incomplete. It's not self-deprecation. It's cognitive accuracy.

The practice requires deliberately asking: "What am I wrong about today?" Not as a rhetorical question, but as a genuine inquiry, followed by actual searching.

THE TWO SIGNATURES OF DEFENSIVE PRIDE:
1. Criticizing others' work unprompted (to establish superiority)
2. Interpreting any correction as personal attack

Both behaviors create isolation. People stop offering honest feedback to those who punish it. The proud person gets less accurate data about themselves, slower, until they're operating with a map that no longer matches the territory.

PRIDE TRAINING PROTOCOL:
→ End each day by writing one thing you were wrong about today.
→ Actively seek one piece of critical feedback per week from someone you trust.
→ When criticized, pause 5 seconds before responding. Ask "Is there truth here?" before defending.
→ Practice saying "I was wrong about that" out loud. Notice how it feels. Train the feeling to normalize.
""",
            imageName: "article_pride_feedback"
        ),
        LibraryEntryHS(
            title: "Lust and the Attention Economy",
            feeling: "lustful",
            content: """
In psychology, "lust" extends far beyond sexuality — it describes the compulsive craving for immediate sensory gratification before deliberate thought can intervene. The modern attention economy is architected entirely around this mechanism.

Netflix autoplay removes the moment of choice between episodes. Instagram infinite scroll eliminates natural stopping points. Food delivery apps reduce the friction between craving and consumption to under 20 minutes. Every design decision is optimized to exploit the brain's lust circuitry — to trigger and fulfill craving so fast that deliberation has no window to engage.

THE PREFRONTAL OVERRIDE PROBLEM:
Your prefrontal cortex — the seat of rational decision-making, delayed gratification, and long-term planning — takes approximately 200-300 milliseconds to engage after an impulse registers. Every system engineered for instant gratification is designed to get you to act before that window opens.

TOLERATING THE GAP:
The discipline of delayed gratification isn't about denial — it's about extending the decision window until rationality can co-sign the choice. Studies show that people who practice tolerating small discomforts and waiting before acting on desires experience:
— Higher life satisfaction scores
— Better financial outcomes
— Stronger relationships (they can tolerate friction without fleeing)
— Greater creative output (they can tolerate the discomfort of empty space before inspiration arrives)

LUST TRAINING PROTOCOL:
→ Identify your "instant gratification" pattern — what do you habitually reach for when mildly uncomfortable?
→ Install a 10-second pause before every gratification-seeking behavior this week.
→ During those 10 seconds, ask: "Is this choice or craving?"
→ You don't have to say no. Just introduce the gap. The gap is where identity is built.
""",
            imageName: "article_lust_attention"
        ),
        LibraryEntryHS(
            title: "The Psychology of Overconsumption",
            feeling: "gluttonous",
            content: """
Gluttony — in its modern psychological form — is not about food alone. It's the behavioral pattern of consuming beyond actual need: food, content, entertainment, social media, shopping, news. It's the compulsive drive to fill a space that cannot be filled by external input.

The neurological signature is identical across all forms: cortisol (stress hormone) drives the brain toward dopamine shortcuts. Ultra-processed food, binge-watching, doom-scrolling — all are pharmacologically similar responses to an overwhelmed nervous system.

WHY YOU CAN'T STOP EATING:
Ultra-processed food is engineered to fail at triggering two key satiety signals: cholecystokinin (released when fat and protein reach the small intestine) and leptin (the long-term satiety hormone released by fat cells). Hyper-palatable food hits the dopamine circuit first and hard, before satiety signals can arrive from your gut (which takes 20 minutes).

THE 20-MINUTE WINDOW:
Eating slowly — actually slowly, not "trying to eat slowly while still rushing" — gives your gut-brain axis time to communicate. Studies show chewing each bite 20+ times and putting utensils down between bites reduces caloric intake by up to 30% without any conscious restriction. Satiety simply arrives before you've over-consumed.

CONTENT OVERCONSUMPTION:
The same mechanism applies to digital content. The brain's satiety signals for information are much slower to activate than the dopamine circuit. You can watch episode after episode, absorbing nothing, feeling vaguely worse — because the consumption was compulsive, not chosen.

GLUTTONY TRAINING PROTOCOL:
→ Eat one meal per day with no screen, phone, or distraction.
→ Chew slowly. Notice flavors, textures, sensations.
→ Implement a "content sabbath" — one day per week with no streaming, no news, no social media.
→ Notice what emotional state drove the last three impulse-consumption events.
""",
            imageName: "article_gluttony_overeat"
        ),
        LibraryEntryHS(
            title: "The Hidden Energy Crisis of Sloth",
            feeling: "tired",
            content: """
Chronic low energy and persistent avoidance are rarely caused by laziness. They are almost always symptoms of an overwhelmed nervous system operating in threat-response mode — a form of biological conservatism where the brain down-regulates motivation and energy output to preserve resources.

When the nervous system perceives that exertion produces no reward — or worse, produces punishment, criticism, or failure — it adapts. It reduces the drive to try. This is not a character flaw. It is an adaptive response to a threatening environment that has outlived its usefulness.

THE ACTIVATION ENERGY PROBLEM:
Newton's first law applies to human psychology: objects at rest tend to stay at rest. The energy required to begin is disproportionate to the energy required to continue. This is the "activation energy barrier."

People mistakenly believe they need to feel motivated before they begin. Neuroscience demonstrates the opposite: action precedes feeling. Motion creates emotion. You cannot wait to feel like starting, because the feeling comes FROM starting.

HACKING THE SYSTEM:
Cold water splashed on the face activates the trigeminal nerve and triggers an immediate sympathetic response — measurable increases in heart rate, alertness, and norepinephrine within seconds. Ten jumping jacks create enough proprioceptive input to shift the nervous system's activation state. A five-minute walk changes the electrochemical environment of the brain.

These are not metaphors. They are physics — using your body's hardware to change your software state.

SLOTH TRAINING PROTOCOL:
→ Replace "I don't feel like it" with "I'll just do one minute."
→ Use a physical activation trigger every morning: cold water on face, 10 push-ups, 5 minutes walking.
→ Track "activation attempts" separately from "completions." Reward the attempt, not the result.
→ Take 3 days of genuine rest — then return. You may discover that sloth was burnout in disguise.
""",
            imageName: "article_sloth_energy"
        ),
        LibraryEntryHS(
            title: "Breaking Habit Loops with the 3R Framework",
            feeling: "stuck",
            content: """
Every behavioral habit — from smoking to phone-checking to overeating to explosive anger — runs on a three-part neurological architecture discovered by MIT researchers studying rats in a maze:

TRIGGER → ROUTINE → REWARD

The Trigger is the cue that launches the behavior. It can be a time of day, an emotional state, a specific location, a person, or an event. Most triggers are unconscious — you don't notice them until you study yourself.

The Routine is the behavior itself — the automatic response activated by the trigger. This path is so grooved in your neurology that it becomes default: efficient, fast, requiring minimal cognitive effort.

The Reward is what the behavior delivers: relief, stimulation, comfort, escape, social connection. The reward doesn't have to be large. It just has to reliably follow the trigger.

WHY WILLPOWER FAILS:
Trying to simply stop a habit through willpower attacks the routine but leaves the trigger and reward structure intact. The trigger still fires. The reward is still awaited. The absence of the routine creates neurological discomfort — a gap the system desperately tries to fill. This is why "just stopping" almost never works long-term.

THE SUBSTITUTION METHOD:
Charles Duhigg's research shows that keeping the trigger and reward constant while substituting the routine has an 85% higher success rate than pure abstinence.

To apply: identify the reward that makes you smoke / scroll / snap. What does it actually give you? Stress relief? Social belonging? Stimulation? Now design a routine that delivers the exact same reward through a different vehicle.

If cigarettes deliver stress relief, box breathing delivers a more potent cortisol reduction through the parasympathetic nervous system — same reward, zero harm.

3R AUDIT EXERCISE:
For one week, every time you perform a habit you want to change, write down:
1. What just happened before I started? (Trigger)
2. What did I actually do? (Routine)
3. What did this give me? (Reward — be honest)

By day 7, you'll have a map that no therapist's assessment could match in precision, because you built it from your own lived data.
""",
            imageName: "article_habit_loops"
        )
    ]
}
