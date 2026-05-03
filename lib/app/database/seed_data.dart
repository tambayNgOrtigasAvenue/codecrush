// ignore_for_file: prefer_single_quotes
part of 'database_helper.dart';

const List<Map<String, dynamic>> _kCourses = [
  {
    'title': 'Figma Master Class',
    'subtitle': 'Design systems and production UI',
    'short_code': 'FIG',
    'lessons_count': 8,
    'duration': 14,
    'author': 'Robertson Connie',
    'level': 'Advance',
    'points': 2000,
    'rating': 4.8,
    'contents': [
      {
        'title': 'Getting Started with Figma',
        'body': '''Figma is a browser-based design tool used by designers worldwide to create UIs, prototypes, and design systems. Unlike desktop-only tools, Figma runs in the cloud — every file is auto-saved and shareable via a link.

When you open Figma for the first time, you will see the Home screen. From here you can create a new Design File, open a FigJam board, or browse community resources.

Key workspace areas:
• Canvas — the infinite white space where you design. Zoom with Ctrl+Scroll or pinch-to-zoom on a trackpad.
• Toolbar — runs across the top. Contains tools: Move (V), Frame (F), Shape (R), Pen (P), Text (T), and Hand (H).
• Layers panel — the left sidebar lists every object on the canvas in a tree. Click the arrow to expand groups.
• Properties panel — the right sidebar shows the selected element\'s fill, stroke, effects, and layout options.
• Assets panel — stores your components, local styles, and installed plugins.

Start by pressing F to activate the Frame tool, then drag out a rectangle. In the right panel you\'ll see preset device sizes — click "iPhone 14" to snap to 390×844. This frame becomes your first screen.'''
      },
      {
        'title': 'Frames, Groups, and Sections',
        'body': '''In Figma, Frames are the primary containers for your designs. They behave like artboards in Sketch or Adobe XD but are far more powerful because they support Auto Layout, clipping, and independent corner radii.

Creating a Frame:
Press F, then drag on the canvas. Or select any elements and press Ctrl+Alt+G (Windows) / Cmd+Option+G (Mac) to wrap them in a frame.

Frame vs. Group:
• A Group (Ctrl+G) is a loose collection — resizing it scales all children proportionally.
• A Frame (Ctrl+Alt+G) is a container with its own dimensions. Children can have fixed sizes or fill the frame.
• Frames can clip their contents (hide anything that overflows), while groups cannot.

Sections are a newer concept in Figma — large coloured regions that help you organise the canvas into zones like "Mobile Flows", "Tablet", or "Archive". Press Shift+S to create one. Sections appear below frames in the layers panel and are not exported.

Pro tip: name your frames with a clear hierarchy like "Home / Feed / Card" to keep the layers panel readable as the project grows.'''
      },
      {
        'title': 'Shapes, Vectors, and the Pen Tool',
        'body': '''Figma provides several shape primitives you can combine to build any icon or illustration.

Built-in shapes (press R for rectangle, O for ellipse):
• Rectangle — hold Shift while dragging to create a perfect square.
• Ellipse — hold Shift for a perfect circle.
• Polygon and Star — find them in the shape dropdown in the toolbar. Adjust sides and ratio in the right panel.
• Line and Arrow — press L or draw directly.

Boolean Operations combine shapes into compound paths:
• Union — merges shapes into one outline.
• Subtract — cuts the top shape out of the bottom.
• Intersect — keeps only the overlapping area.
• Exclude — keeps only the non-overlapping area.
Select two shapes and choose the operation from the toolbar dropdown.

The Pen Tool (P) lets you draw custom vector paths by placing anchor points. Click to create a straight corner; click and drag to create a curved Bezier point. Press Enter to finish the path, or press Escape to discard.

After drawing, use the Edit Vector (Enter) mode to adjust individual points. Drag point handles to control curve tension. Double-click a segment to add a new point.'''
      },
      {
        'title': 'Text and Typography',
        'body': '''Good typography is the backbone of a clear UI. Figma gives you full control over type styles, including Google Fonts integration.

Creating text:
Press T, click on the canvas to create a single-line text box, or click and drag to create a fixed-width box. Type your content. Press Escape when done.

Key properties in the right panel:
• Font family — search for any Google Font directly (e.g., "Inter", "Outfit").
• Font weight — Regular, Medium, SemiBold, Bold, etc.
• Font size — in px. Common UI sizes: 12px caption, 14px body, 16px default, 20px heading, 32-48px display.
• Line height — percentage (140%) or fixed px. 150% is a comfortable reading value for body text.
• Letter spacing — nudge with +/- values. Slight positive spacing (5-10%) improves uppercase readability.
• Paragraph spacing — gap between paragraphs.
• Text align — left, center, right, justified.
• Truncation — clip, overflow, or ellipsis mode.

Text Styles let you save and reuse type settings. Click the four-dot grid icon in the Text section of the right panel → "+" to create a style. Give it a name like "Body/Regular" or "Heading/H1".

Resizing behaviour:
• Auto width — box grows horizontally as you type.
• Auto height — box grows vertically when content wraps.
• Fixed size — text clips or overflows the defined box.'''
      },
      {
        'title': 'Components and Variants',
        'body': '''Components are the most powerful Figma feature. They let you define a UI element once and reuse it across the entire file. When you edit the main component, every instance updates automatically.

Creating a component:
Select the layers you want to componentise and press Ctrl+Alt+K (Windows) / Cmd+Option+K (Mac). The frame turns purple and shows a diamond icon in the layers panel. The original becomes the Main Component; every copy you paste is an Instance.

Overriding instances:
Instances inherit the main component\'s structure but you can override text content, fills, images, and visibility without breaking the link. To reset an override, right-click the instance → "Reset all overrides".

Variants group multiple states of a component into one block:
1. Create all states of your component (e.g., Button Default, Button Hover, Button Disabled).
2. Select all of them.
3. Click "Combine as variants" in the right panel.
4. A dashed purple boundary appears around the variant set.
5. Name each variant with a Property=Value pair, e.g., State=Default, State=Hover.

In any instance, you can now switch the variant using the dropdown in the right panel. Use multiple properties for complex components: Size=Large, Variant=Filled, State=Default.

Component properties (added in Figma 2022):
• Boolean — toggle a layer on/off (e.g., show/hide an icon).
• Text — replace text content from the properties panel.
• Instance swap — swap a nested component (e.g., replace an icon).'''
      },
      {
        'title': 'Auto Layout',
        'body': '''Auto Layout transforms a static frame into a smart container that resizes dynamically based on its content. It is the key to building UI that behaves like real CSS Flexbox.

Adding Auto Layout:
Select a frame or group and press Shift+A. You can also right-click → "Add Auto Layout".

Direction:
• Horizontal — children stack left-to-right (like flex-direction: row).
• Vertical — children stack top-to-bottom (like flex-direction: column).
• Wrap — children wrap to the next line when the container is full.

Spacing and padding:
• Gap between items — the space between each child element.
• Horizontal and vertical padding — the space between the container edge and its children.
You can set all four padding values independently.

Sizing modes for the container:
• Hug contents — the frame shrinks to fit its children.
• Fixed — the frame stays the same size regardless of children.
• Fill container — the frame stretches to fill its parent Auto Layout frame.

Sizing modes for children:
• Fixed — the child keeps its set width/height.
• Fill container — the child stretches to fill the available space (like flex: 1 in CSS).
• Hug contents — the child shrinks to fit its own content.

Alignment: use the alignment grid in the right panel to control where children sit within the container — start, center, end, or space-between.

Absolute position: any child can be taken out of the layout flow with "Absolute position" in the right panel. This pins it relative to the parent frame, useful for overlaying badges or floating buttons.'''
      },
      {
        'title': 'Design Systems and Styles',
        'body': '''A design system is a collection of reusable components, documented standards, and design tokens that ensure consistency across an entire product. Figma is the ideal tool for building and maintaining one.

Local styles:
Figma lets you save colours, text, effects, and grids as named styles. To create a style, click the "+" next to the relevant section in the right panel. Apply a colour style by clicking the swatch next to Fill and selecting from the panel.

Naming convention — use slashes to create groups:
• Colors/Primary/500
• Colors/Neutral/100
• Text/Heading/H1
• Effects/Shadow/Card

Variables (Figma 2023+):
Variables store raw design tokens — you can define a variable "color-primary" with different values for light and dark mode collections. Variables can be numbers, strings, booleans, or colours. Apply them directly to fill, stroke, spacing, and corner radius properties.

Publishing a library:
In a dedicated "Design System" file, create all your components and styles, then go to Assets → click the book icon → "Publish styles and components". Any team member can now enable this library in their own files via the Assets panel → Libraries toggle.

Versioning and branching:
Use Figma Branches (Figma Organisation plan) to propose changes to the main library without breaking live files. Branches are like Git branches — merge them when approved.'''
      },
      {
        'title': 'Prototyping and Developer Handoff',
        'body': '''Figma\'s built-in prototyping connects your frames with interactive flows so stakeholders can experience the product before a single line of code is written.

Building a prototype:
1. Switch to the Prototype tab in the right panel.
2. Hover over any element — a blue "+" handle appears on the edge.
3. Drag from the handle to the destination frame.
4. Set the Trigger: On Click, On Hover, On Drag, Key/Gamepad, After Delay, Mouse Enter/Leave.
5. Set the Action: Navigate to, Open overlay, Back, Scroll to, Set variable.
6. Set the Animation: Instant, Dissolve, Smart Animate, Move In/Out, Push, Slide In/Out.

Smart Animate:
When Smart Animate is chosen, Figma automatically tweens matching layer names between frames. This creates smooth morph transitions without any extra work — just name layers consistently.

Viewing the prototype:
Press Ctrl+Alt+Enter (Windows) / Cmd+Option+Return (Mac) or click the Play button (▶) in the top bar. Share a prototype link with stakeholders via "Share prototype" — no Figma account required to view.

Developer handoff:
Figma generates code snippets automatically:
• CSS for web (fill, border, font, shadow, flex layout).
• iOS (Swift UIKit/SwiftUI values).
• Android (XML dp values).
Developers open Inspect mode (click Dev Mode toggle top-right) to copy values, view spacing, and download exported assets. Set export settings (PNG, SVG, PDF) on any layer in the right panel → Export section.'''
      },
    ],
  },
  {
    'title': 'React',
    'subtitle': 'Build interactive UIs with components',
    'short_code': 'RE',
    'lessons_count': 8,
    'duration': 12,
    'author': 'freeCodeCamp',
    'level': 'Beginner',
    'points': 2000,
    'rating': 4.9,
    'contents': [
      {
        'title': 'Create a Simple JSX Element',
        'body': '''React is an Open Source view library created and maintained by Facebook. It is a great tool to render the User Interface (UI) of modern web applications.

React uses a syntax extension of JavaScript called JSX that allows you to write HTML directly within JavaScript. This has several benefits — it lets you use the full programmatic power of JavaScript within HTML, and helps to keep your code readable.

For the most part, JSX is similar to the HTML that you have already learned. However there are a few key differences. Because JSX is a syntactic extension of JavaScript, you can write JavaScript directly within JSX by wrapping it in curly braces:

  { \'this is treated as JavaScript code\' }

However, because JSX is not valid JavaScript, JSX code must be compiled into JavaScript. The transpiler Babel is a popular tool for this process.

It is worth noting that under the hood the challenges are calling:

  ReactDOM.render(JSX, document.getElementById(\'root\'))

This function call places your JSX into React\'s own lightweight representation of the DOM. React then uses snapshots of its own DOM to optimize updating only specific parts of the actual DOM.

Your first JSX element:

  const JSX = <h1>Hello JSX!</h1>;

Notice there are no quotes around the JSX. This is not a string — it is a JSX expression that React knows how to render.'''
      },
      {
        'title': 'Create a Complex JSX Element',
        'body': '''The last lesson was a simple example of JSX, but JSX can represent more complex HTML as well.

One important thing to know about nested JSX is that it must return a single parent element. This one parent element wraps all of the other levels of nested elements.

Valid JSX — single parent wraps all children:

  const JSX = (
    <div>
      <h1>Hello World</h1>
      <p>Some info</p>
      <ul>
        <li>An item</li>
        <li>Another item</li>
        <li>A third item</li>
      </ul>
    </div>
  );

Invalid JSX — sibling elements with no parent wrapper:

  const JSX = (
    <h1>Hello World</h1>
    <p>Some info</p>
  );

The invalid example will throw a compile error because JSX expressions must have exactly one root element.

When rendering multiple elements you can wrap them all in parentheses, but it is not strictly required. Notice this example uses a div tag to wrap all the child elements within a single parent element. If you remove the div, the JSX will no longer compile. Keep this in mind since it also applies when you return JSX elements in React components.

A modern alternative to adding a wrapping div is the React Fragment shorthand, which renders no extra DOM node:

  const JSX = (
    <>
      <h1>Hello</h1>
      <p>World</p>
    </>
  );'''
      },
      {
        'title': 'Add Comments in JSX',
        'body': '''JSX is a syntax that gets compiled into valid JavaScript. Sometimes, for readability, you might need to add comments to your code. Like most programming languages, JSX has its own way to do this.

To put comments inside JSX, you use the syntax {/* */} to wrap around the comment text:

  const JSX = (
    <div>
      <h1>This is a block of JSX</h1>
      {/* this is a JSX comment */}
      <p>Here is a subtitle</p>
    </div>
  );

This is different from a regular JavaScript comment (//) because JSX is ultimately compiled to function calls. Plain JS comments inside JSX markup won\'t work — you must always use the curly brace syntax {/* ... */} when writing comments inside a JSX expression.

Why do JSX comments work differently?
Under the hood, <h1>Hello</h1> compiles to React.createElement(\'h1\', null, \'Hello\'). Because JSX is really just function calls, any comment syntax must be inside a JavaScript expression (curly braces). The /* */ style works there because it is valid inside a JS expression, while // would comment out everything to the end of the line, breaking the JSX.

You can place the comment anywhere inside the JSX as long as it is wrapped in curly braces:

  <div {/* comment on opening tag line */}>
    {/* comment on its own line */}
    <p>Content</p>
  </div>'''
      },
      {
        'title': 'Render HTML Elements to the DOM',
        'body': '''So far, you\'ve learned that JSX is a convenient tool to write readable HTML within JavaScript. With React, we can render this JSX directly to the HTML DOM using React\'s rendering API known as ReactDOM.

ReactDOM offers a simple method to render React elements to the DOM:

  ReactDOM.render(componentToRender, targetNode)

The first argument is the React element or component that you want to render. The second argument is the DOM node that you want to render the component to.

ReactDOM.render() must be called after the JSX element declarations, just like how you must declare variables before using them.

Full example:

  const JSX = (
    <div>
      <h1>Hello World</h1>
      <p>Lets render this to the DOM</p>
    </div>
  );

  ReactDOM.render(JSX, document.getElementById(\'root\'));

This is the fundamental pattern behind every React application — describe what the UI looks like with JSX, then hand it to ReactDOM to take care of the actual DOM updates.

React 18 and the new root API:
In React 18, the preferred method changed slightly:

  import { createRoot } from \'react-dom/client\';

  const root = createRoot(document.getElementById(\'root\'));
  root.render(<App />);

The new API enables concurrent features like transitions and Suspense. Most modern React projects use this pattern.'''
      },
      {
        'title': 'Define an HTML Class in JSX',
        'body': '''Now that you\'re getting comfortable writing JSX, you may be wondering how it differs from HTML.

So far, it may seem that HTML and JSX are exactly the same. One key difference is in the word class. Whereas HTML uses class to define CSS classes, JSX uses className, because class is a reserved keyword in JavaScript.

In HTML:

  <div class="container">Hello</div>

In JSX:

  const JSX = <div className="container">Hello</div>;

In fact, the naming convention for all HTML attributes and event references in JSX become camelCase. For example, a click event in HTML is onclick, but in JSX it becomes onClick. A form submit event in HTML is onsubmit, but in JSX it is onSubmit.

Other common attribute differences:
• for (HTML label attribute) → htmlFor in JSX
• tabindex → tabIndex
• readonly → readOnly
• maxlength → maxLength
• autocomplete → autoComplete
• colspan → colSpan
• rowspan → rowSpan

Self-closing tags:
Any element can be self-closing in JSX. For elements that are traditionally self-closing in HTML (like <br>, <img>, <input>), the trailing slash is required in JSX:

  <br />
  <img src="logo.png" alt="Logo" />
  <input type="text" />

For normally-open elements, you can self-close if there are no children:

  <div className="spacer" />'''
      },
      {
        'title': 'Create a Stateless Functional Component',
        'body': '''Components are the core of React. Everything in React is a component, and you will learn how to create new components.

There are two ways to create a React component. The first way is to use a JavaScript function. Defining a component in this way creates a stateless functional component. The concept of state in an application will be covered in later lessons.

For now, think of a stateless functional component as one that can receive data and render it, but does not manage or track changes to that data.

To create a component with a function, you simply write a JavaScript function that returns either JSX or null:

  const MyComponent = function() {
    return (
      <div>
        <h1>Hello from MyComponent</h1>
      </div>
    );
  };

Note: React requires your component name to begin with a capital letter. This is how React distinguishes between a regular HTML tag (lowercase) and a custom component (PascalCase).

Arrow function components — the modern style:

  const MyComponent = () => {
    return <div>Hello!</div>;
  };

With implicit return (single expression):

  const MyComponent = () => <div>Hello!</div>;

Using the component in JSX:

  ReactDOM.render(<MyComponent />, document.getElementById(\'root\'));

Functional components are the recommended way to write React code today. Since the introduction of Hooks in React 16.8, functional components can do everything class components can.'''
      },
      {
        'title': 'Props — Passing Data to Components',
        'body': '''In React, you can pass data into a component using props (short for properties). Props allow you to build generic, reusable components and supply them with different data each time they are used.

Passing props:

  <Welcome name="Sara" age={25} />

Receiving props in a functional component:

  const Welcome = (props) => {
    return <h1>Hello, {props.name}! You are {props.age} years old.</h1>;
  };

Or with destructuring (cleaner):

  const Welcome = ({ name, age }) => {
    return <h1>Hello, {name}! You are {age} years old.</h1>;
  };

Default props — supply fallback values when a prop is not provided:

  Welcome.defaultProps = {
    name: \'Stranger\',
    age: 0,
  };

Or inline with destructuring defaults:

  const Welcome = ({ name = \'Stranger\', age = 0 }) => (
    <h1>Hello, {name}! You are {age} years old.</h1>
  );

PropTypes — runtime type checking (development only):

  import PropTypes from \'prop-types\';

  Welcome.propTypes = {
    name: PropTypes.string.isRequired,
    age: PropTypes.number,
  };

Passing children:
Any content nested between opening and closing component tags is available as props.children:

  const Card = ({ children }) => <div className="card">{children}</div>;

  <Card>
    <h2>Title</h2>
    <p>Body text here</p>
  </Card>'''
      },
      {
        'title': 'State and the useState Hook',
        'body': '''State is data that changes over time and drives the UI to re-render. The useState Hook is the most fundamental way to add state to a functional component.

Basic syntax:

  import { useState } from \'react\';

  const [value, setValue] = useState(initialValue);

• value — the current state.
• setValue — a function that updates the state and triggers a re-render.
• initialValue — what the state starts as (number, string, object, array, boolean, etc.).

Counter example:

  import { useState } from \'react\';

  function Counter() {
    const [count, setCount] = useState(0);
    return (
      <div>
        <p>Count: {count}</p>
        <button onClick={() => setCount(count + 1)}>Increment</button>
        <button onClick={() => setCount(count - 1)}>Decrement</button>
        <button onClick={() => setCount(0)}>Reset</button>
      </div>
    );
  }

Functional update form — use when the new state depends on the previous state:

  setCount(prev => prev + 1);

This form is safer inside event handlers and async callbacks because it always has the latest value.

State with objects:

  const [user, setUser] = useState({ name: \'\', email: \'\' });

  // Always spread the old state — never mutate directly
  setUser(prev => ({ ...prev, name: \'Ken\' }));

Rules of Hooks:
1. Only call Hooks at the top level of a component (not inside loops, conditions, or nested functions).
2. Only call Hooks from React function components (or custom Hooks).'''
      },
    ],
  },
  // ── JAVASCRIPT ───────────────────────────────────────────────────────────
  {
    'title': 'JavaScript',
    'subtitle': 'The language of the web',
    'short_code': 'JS',
    'lessons_count': 8,
    'duration': 12,
    'author': 'freeCodeCamp',
    'level': 'Beginner',
    'points': 1500,
    'rating': 4.8,
    'contents': [
      {
        'title': 'Variables: var, let, and const',
        'body': '''In JavaScript, variables are containers that store data values. There are three keywords used to declare them: var, let, and const.

var (old way — avoid in modern code):
  var x = 5;
  var x = 10; // allowed — can be re-declared
  x = 20;     // allowed — can be reassigned

Problems with var: it is function-scoped (not block-scoped) and is hoisted to the top of its function, which can cause confusing bugs.

let (ES6, preferred for mutable values):
  let count = 0;
  count = 1; // allowed — can be reassigned
  // let count = 2; // error — cannot be re-declared in the same scope

const (ES6, preferred for fixed values):
  const PI = 3.14159;
  // PI = 3; // error — cannot be reassigned
  // const PI = 3; // error — cannot be re-declared

Rule of thumb:
• Use const by default.
• Use let when you know the variable will be reassigned.
• Never use var in new code.

Variable naming rules:
• Must start with a letter, underscore (_), or dollar sign (\$).
• Cannot start with a number.
• Case-sensitive: myVar and myvar are different variables.
• Use camelCase by convention: firstName, totalScore.'''
      },
      {
        'title': 'Data Types',
        'body': '''JavaScript has eight data types. The first seven are called primitive types, and the eighth is Object.

Primitive types:
1. Number — integers and decimals: 42, 3.14, -7, Infinity, NaN
2. String — text wrapped in quotes: "hello", \'world\', \`template\`
3. Boolean — true or false
4. Undefined — a variable declared but not yet assigned a value
5. Null — intentionally empty value (typeof null === "object" is a known bug)
6. Symbol — unique identifiers (ES6)
7. BigInt — very large integers: 9007199254740991n

Object type:
  const user = { name: "Ken", age: 25 };
  const scores = [10, 20, 30]; // arrays are objects
  const greet = function() {}; // functions are objects

Checking types with typeof:
  typeof 42           // "number"
  typeof "hello"      // "string"
  typeof true         // "boolean"
  typeof undefined    // "undefined"
  typeof null         // "object" (bug in JS)
  typeof {}           // "object"
  typeof []           // "object"
  typeof function(){} // "function"

Type coercion — JavaScript automatically converts types in operations:
  "5" + 3   // "53" (number becomes string)
  "5" - 3   // 2    (string becomes number)
  true + 1  // 2    (true converts to 1)

Always use === (strict equality) instead of == to avoid unexpected coercion:
  0 == false   // true  (coercion)
  0 === false  // false (no coercion)'''
      },
      {
        'title': 'Functions',
        'body': '''Functions are reusable blocks of code. JavaScript has several ways to define them.

Function declaration (hoisted — can be called before its definition):
  function greet(name) {
    return "Hello, " + name;
  }
  greet("Ken"); // "Hello, Ken"

Function expression (not hoisted):
  const greet = function(name) {
    return "Hello, " + name;
  };

Arrow function (ES6 — concise syntax, no own this):
  const greet = (name) => "Hello, " + name;

  // Multiple statements require braces and explicit return:
  const add = (a, b) => {
    const result = a + b;
    return result;
  };

Parameters and arguments:
  function power(base, exponent = 2) { // default parameter
    return base ** exponent;
  }
  power(3);    // 9  (exponent defaults to 2)
  power(3, 3); // 27

Rest parameters — collect remaining arguments into an array:
  function sum(...numbers) {
    return numbers.reduce((acc, n) => acc + n, 0);
  }
  sum(1, 2, 3, 4); // 10

Return values:
A function without a return statement returns undefined. Use return to pass data back to the caller.'''
      },
      {
        'title': 'Arrays',
        'body': '''Arrays store ordered collections of values. They are zero-indexed: the first element is at index 0.

Creating arrays:
  const fruits = ["apple", "banana", "cherry"];
  const mixed  = [1, "two", true, null];
  const empty  = [];

Accessing elements:
  fruits[0]  // "apple"
  fruits[2]  // "cherry"
  fruits[fruits.length - 1] // last element: "cherry"

Common array methods:

push / pop — add/remove from the end:
  fruits.push("date");   // ["apple","banana","cherry","date"]
  fruits.pop();          // removes "date"

unshift / shift — add/remove from the start:
  fruits.unshift("avocado"); // adds to front
  fruits.shift();            // removes from front

splice — remove or insert at any position:
  fruits.splice(1, 1);           // removes 1 element at index 1
  fruits.splice(1, 0, "blueberry"); // inserts at index 1

slice — returns a copy of a portion (non-destructive):
  fruits.slice(0, 2) // ["apple", "banana"]

Iteration methods:
  fruits.forEach(f => console.log(f));
  const upper = fruits.map(f => f.toUpperCase());
  const long  = fruits.filter(f => f.length > 5);
  const found = fruits.find(f => f.startsWith("b")); // "banana"
  const total = [1,2,3].reduce((acc, n) => acc + n, 0); // 6'''
      },
      {
        'title': 'Objects',
        'body': '''Objects store key-value pairs. They are the foundation of most JavaScript data structures.

Creating an object:
  const user = {
    name: "Ken",
    age: 25,
    isAdmin: false,
    address: {
      city: "Manila",
      zip: "1000"
    }
  };

Accessing properties:
  user.name          // "Ken"        (dot notation)
  user["age"]        // 25           (bracket notation — useful for dynamic keys)
  user.address.city  // "Manila"     (nested access)

Adding and updating:
  user.email = "ken@example.com"; // add new property
  user.age = 26;                  // update existing

Deleting:
  delete user.isAdmin;

Object methods — functions stored as properties:
  const calculator = {
    value: 0,
    add(n) { this.value += n; return this; },
    result() { return this.value; }
  };
  calculator.add(5).add(3).result(); // 8

Destructuring — extract properties into variables:
  const { name, age } = user;
  const { address: { city } } = user; // nested destructuring

Spread operator — copy or merge objects:
  const updated = { ...user, age: 27 }; // creates new object with age overridden

Object.keys / values / entries:
  Object.keys(user)    // ["name", "age", ...]
  Object.values(user)  // ["Ken", 25, ...]
  Object.entries(user) // [["name","Ken"], ["age",25], ...]'''
      },
      {
        'title': 'Scope and Closures',
        'body': '''Understanding scope is essential to writing predictable JavaScript.

Global scope — variables declared outside any function or block are globally accessible.
  let globalVar = "I am global";

Function scope — var is scoped to its nearest enclosing function.
  function myFunc() {
    var local = "only inside";
  }
  // local is not accessible here

Block scope — let and const are scoped to the nearest { } block.
  if (true) {
    let blockVar = "block scoped";
    const blockConst = "also block";
  }
  // blockVar and blockConst are not accessible here

Scope chain — when JavaScript looks up a variable, it starts in the current scope and walks up through enclosing scopes until it finds the variable or reaches the global scope.

Closures:
A closure is formed when an inner function retains access to variables from its outer function even after the outer function has returned.

  function makeCounter() {
    let count = 0;
    return {
      increment() { count++; },
      decrement() { count--; },
      value()     { return count; }
    };
  }

  const counter = makeCounter();
  counter.increment();
  counter.increment();
  counter.value(); // 2

"count" is private — it cannot be accessed directly from outside. Closures enable data encapsulation without classes.

Common closure gotcha:
  for (var i = 0; i < 3; i++) {
    setTimeout(() => console.log(i), 100); // prints 3, 3, 3
  }
  // Fix: use let (creates a new binding per iteration)
  for (let i = 0; i < 3; i++) {
    setTimeout(() => console.log(i), 100); // prints 0, 1, 2
  }'''
      },
      {
        'title': 'Promises and Async/Await',
        'body': '''JavaScript is single-threaded. Asynchronous operations (network requests, timers, file reads) use the event loop so they never block the UI thread.

Callbacks (old way — leads to "callback hell"):
  fetchData(function(result) {
    processResult(result, function(output) {
      saveOutput(output, function() {
        console.log("done");
      });
    });
  });

Promises (ES6):
A Promise represents a value that will be available in the future. It is in one of three states: pending, fulfilled, or rejected.

  const p = fetch("/api/user/1");

  p.then(response => response.json())
   .then(data    => console.log(data))
   .catch(error  => console.error(error))
   .finally(()   => console.log("request done"));

Creating your own Promise:
  function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  delay(1000).then(() => console.log("1 second passed"));

Async/Await (ES2017 — syntactic sugar over Promises):
  async function loadUser(id) {
    try {
      const response = await fetch("/api/users/" + id);
      const user     = await response.json();
      return user;
    } catch (err) {
      console.error("Failed:", err);
    }
  }

Rules:
• async functions always return a Promise.
• await pauses execution until the Promise settles.
• Wrap await calls in try/catch to handle errors.

Running multiple Promises in parallel:
  const [user, posts] = await Promise.all([
    fetch("/api/user").then(r => r.json()),
    fetch("/api/posts").then(r => r.json()),
  ]);'''
      },
      {
        'title': 'ES6+ Modern Features',
        'body': '''ES6 (ECMAScript 2015) and later versions introduced many features that make JavaScript cleaner and more powerful. Here is a summary of the most important ones.

Template literals — embed expressions inside strings using backticks:
  const name = "Ken";
  const msg = "Hello, " + name + "!";  // old
  const msg = \`Hello, \${name}!\`;       // new

Destructuring — unpack arrays and objects:
  const [a, b] = [1, 2];
  const { name, age } = user;

Spread and rest operators:
  const arr2 = [...arr1, 4, 5];           // spread
  const merged = { ...obj1, ...obj2 };    // spread
  function sum(...args) { return args.reduce((a,b) => a+b, 0); } // rest

Optional chaining (?.) — safely access nested properties:
  const city = user?.address?.city; // undefined if any part is null/undefined

Nullish coalescing (??) — provide a default only for null/undefined:
  const name = user.name ?? "Anonymous"; // only falls back if null or undefined

Short-circuit evaluation:
  const value = input || "default"; // falls back if input is any falsy value

Modules (import / export):
  // math.js
  export function add(a, b) { return a + b; }
  export const PI = 3.14;

  // main.js
  import { add, PI } from "./math.js";

Class syntax:
  class Animal {
    constructor(name) { this.name = name; }
    speak() { return this.name + " makes a sound"; }
  }
  class Dog extends Animal {
    speak() { return this.name + " barks"; }
  }'''
      },
    ],
  },
  // ── TYPESCRIPT ───────────────────────────────────────────────────────────
  {
    'title': 'TypeScript',
    'subtitle': 'Typed JavaScript for large apps',
    'short_code': 'TS',
    'lessons_count': 8,
    'duration': 10,
    'author': 'Robertson Connie',
    'level': 'Intermediate',
    'points': 1500,
    'rating': 4.7,
    'contents': [
      {
        'title': 'Why TypeScript?',
        'body': '''TypeScript is a strongly typed programming language that builds on JavaScript by adding optional static types. It was developed by Microsoft and is the language of choice for large-scale JavaScript applications.

Why use TypeScript?
• Catch errors at compile time — before your code ever runs.
• Better editor support — autocomplete, refactoring, and inline documentation improve dramatically because the editor knows the exact type of every variable.
• Self-documenting code — a function signature like getUserById(id: number): Promise<User> tells you exactly what it expects and returns.
• Scales with team size — types serve as contracts between different parts of the codebase, reducing integration bugs.

TypeScript is a superset of JavaScript — every valid .js file is valid .ts, so you can adopt it gradually.

Installation:
  npm install -g typescript
  tsc --init  // creates tsconfig.json

Compiling:
  tsc index.ts  // produces index.js

Running with ts-node (no compile step):
  npx ts-node index.ts

Basic type annotations:
  let username: string = "Ken";
  let age: number = 25;
  let isActive: boolean = true;
  let scores: number[] = [95, 87, 100];
  let anything: any = "avoid this";

TypeScript infers types automatically:
  let count = 0; // TypeScript infers: number
  count = "ten"; // Error: Type string is not assignable to type number'''
      },
      {
        'title': 'Interfaces',
        'body': '''An interface defines the shape (structure) of an object. It is TypeScript\'s primary way to describe what properties an object must have.

Defining an interface:
  interface User {
    id: number;
    name: string;
    email: string;
    age?: number;  // optional property
    readonly createdAt: Date; // cannot be changed after assignment
  }

Using the interface:
  function greetUser(user: User): string {
    return "Hello, " + user.name;
  }

  const newUser: User = {
    id: 1,
    name: "Ken",
    email: "ken@example.com",
    createdAt: new Date(),
  };
  greetUser(newUser);

Interface for function types:
  interface Formatter {
    (input: string): string;
  }
  const upperCase: Formatter = (s) => s.toUpperCase();

Interface for index signatures (dictionary-like objects):
  interface StringMap {
    [key: string]: string;
  }
  const labels: StringMap = { title: "Home", nav: "Menu" };

Declaration merging — interfaces can be extended across multiple declarations:
  interface Window { myApp: boolean; }
  interface Window { version: string; }
  // Both merge into one: Window has both myApp and version

Extending interfaces:
  interface Admin extends User {
    role: "superadmin" | "moderator";
    permissions: string[];
  }'''
      },
      {
        'title': 'Type Aliases and Union Types',
        'body': '''A type alias creates a name for any type — primitives, unions, tuples, objects, or functions.

Basic type alias:
  type ID = string | number;
  type Callback = () => void;
  type Point = { x: number; y: number };

Union types — a value can be one of several types:
  type Status = "active" | "inactive" | "pending";
  let userStatus: Status = "active";
  // userStatus = "unknown"; // Error

Union with primitives:
  type StringOrNumber = string | number;
  function printId(id: StringOrNumber) {
    if (typeof id === "string") {
      console.log(id.toUpperCase());
    } else {
      console.log(id.toFixed(2));
    }
  }

Intersection types — combine multiple types into one:
  type Admin = User & { role: string };
  // Admin must have all User properties PLUS role

Type alias vs Interface:
• Both can describe object shapes.
• Interfaces support declaration merging; type aliases do not.
• Type aliases support unions and intersections; interfaces do not directly.
• Use interface for object shapes that may be extended; use type for unions, tuples, and mapped types.

Literal types — restrict a value to an exact set:
  type Direction = "north" | "south" | "east" | "west";
  type DiceRoll = 1 | 2 | 3 | 4 | 5 | 6;

Tuple types — fixed-length arrays with specific types per index:
  type Pair = [string, number];
  const entry: Pair = ["score", 100];'''
      },
      {
        'title': 'Generics',
        'body': '''Generics allow you to write functions, classes, and interfaces that work with any type while still maintaining type safety. They are like type parameters.

Generic function:
  function identity<T>(arg: T): T {
    return arg;
  }
  identity<string>("hello"); // T is string
  identity<number>(42);      // T is number
  identity("inferred");      // TypeScript infers T = string

Generic with multiple type parameters:
  function pair<A, B>(first: A, second: B): [A, B] {
    return [first, second];
  }
  pair<string, number>("age", 25); // ["age", 25]

Generic constraint — restrict T to types that have certain properties:
  function getLength<T extends { length: number }>(arg: T): number {
    return arg.length;
  }
  getLength("hello");     // 5
  getLength([1, 2, 3]);   // 3
  // getLength(42);       // Error: number has no length

Generic interface:
  interface ApiResponse<T> {
    data: T;
    status: number;
    message: string;
    timestamp: Date;
  }

  type UserResponse = ApiResponse<User>;
  type ListResponse = ApiResponse<User[]>;

Generic class:
  class Stack<T> {
    private items: T[] = [];
    push(item: T)    { this.items.push(item); }
    pop(): T | undefined { return this.items.pop(); }
    peek(): T | undefined { return this.items[this.items.length - 1]; }
  }

  const numStack = new Stack<number>();
  numStack.push(1);
  numStack.push(2);
  numStack.pop(); // 2'''
      },
      {
        'title': 'Type Guards and Narrowing',
        'body': '''Type narrowing is the process of refining a broad type to a more specific one based on runtime checks. TypeScript understands these checks and narrows the type inside each branch.

typeof guard:
  function formatInput(input: string | number) {
    if (typeof input === "string") {
      return input.toUpperCase(); // TypeScript knows: string here
    }
    return input.toFixed(2); // TypeScript knows: number here
  }

instanceof guard — check if an object is an instance of a class:
  function handleEvent(event: MouseEvent | KeyboardEvent) {
    if (event instanceof MouseEvent) {
      console.log(event.clientX, event.clientY);
    } else {
      console.log(event.key);
    }
  }

in operator — check if a property exists in an object:
  interface Cat { meow(): void; }
  interface Dog { bark(): void; }

  function makeSound(animal: Cat | Dog) {
    if ("meow" in animal) {
      animal.meow();
    } else {
      animal.bark();
    }
  }

Custom type guard (type predicate):
  function isCat(animal: Cat | Dog): animal is Cat {
    return (animal as Cat).meow !== undefined;
  }
  if (isCat(pet)) pet.meow();

Discriminated unions — a shared literal property narrows the type:
  type Shape =
    | { kind: "circle"; radius: number }
    | { kind: "square"; side: number };

  function area(shape: Shape): number {
    switch (shape.kind) {
      case "circle": return Math.PI * shape.radius ** 2;
      case "square": return shape.side ** 2;
    }
  }

Non-null assertion (!) — tell TypeScript a value is not null/undefined:
  const el = document.getElementById("app")!;'''
      },
      {
        'title': 'Classes in TypeScript',
        'body': '''TypeScript extends JavaScript classes with access modifiers, readonly, abstract, and full interface implementation support.

Basic class:
  class Animal {
    name: string;
    constructor(name: string) {
      this.name = name;
    }
    speak(): string {
      return this.name + " makes a sound";
    }
  }

Access modifiers:
  class BankAccount {
    public owner: string;         // accessible everywhere (default)
    private balance: number;      // only inside this class
    protected accountId: string;  // this class and subclasses
    readonly createdAt: Date;     // can only be set in constructor

    constructor(owner: string, balance: number) {
      this.owner = owner;
      this.balance = balance;
      this.accountId = Math.random().toString(36);
      this.createdAt = new Date();
    }

    getBalance() { return this.balance; }
    deposit(amount: number) { this.balance += amount; }
  }

Shorthand constructor parameters — declare and assign in one step:
  class Point {
    constructor(public x: number, public y: number) {}
    toString() { return "(" + this.x + ", " + this.y + ")"; }
  }

Implementing an interface:
  interface Serializable {
    serialize(): string;
  }
  class Config implements Serializable {
    serialize() { return JSON.stringify(this); }
  }

Abstract classes — cannot be instantiated, must be extended:
  abstract class Shape {
    abstract area(): number;
    describe() { return "Area is " + this.area(); }
  }
  class Circle extends Shape {
    constructor(private radius: number) { super(); }
    area() { return Math.PI * this.radius ** 2; }
  }'''
      },
      {
        'title': 'Utility Types',
        'body': '''TypeScript includes a set of built-in generic utility types that make it easy to transform existing types without rewriting them.

Partial<T> — makes all properties optional:
  interface User { id: number; name: string; email: string; }
  type PartialUser = Partial<User>;
  // { id?: number; name?: string; email?: string }
  function updateUser(id: number, changes: Partial<User>) { ... }

Required<T> — makes all properties required:
  type RequiredUser = Required<PartialUser>;

Readonly<T> — makes all properties readonly:
  const config: Readonly<Config> = loadConfig();
  // config.port = 3000; // Error

Pick<T, Keys> — create a type with only selected properties:
  type UserPreview = Pick<User, "id" | "name">;
  // { id: number; name: string }

Omit<T, Keys> — create a type without selected properties:
  type UserWithoutEmail = Omit<User, "email">;

Record<Keys, Type> — create an object type with specific keys and value type:
  type RoleMap = Record<"admin" | "user" | "guest", string[]>;

Exclude<T, U> — remove types from a union:
  type T = Exclude<string | number | boolean, boolean>;
  // string | number

Extract<T, U> — keep only types assignable to U:
  type T = Extract<string | number | boolean, string | number>;
  // string | number

ReturnType<T> — extract the return type of a function:
  function getUser() { return { id: 1, name: "Ken" }; }
  type User = ReturnType<typeof getUser>;
  // { id: number; name: string }

Parameters<T> — extract the parameter types of a function as a tuple:
  type Params = Parameters<typeof getUser>; // []'''
      },
      {
        'title': 'tsconfig and Project Setup',
        'body': '''The tsconfig.json file controls how TypeScript compiles your project. Understanding it is essential for configuring a real project.

Generating tsconfig.json:
  tsc --init

Important compiler options:

target — the JavaScript version to compile to:
  "target": "ES2020"  // or "ES6", "ESNext", "ES5"

module — the module system to use:
  "module": "CommonJS"  // for Node.js
  "module": "ESNext"    // for modern bundlers (Vite, webpack)

strict — enables all strict type checks (recommended):
  "strict": true
  // Enables: strictNullChecks, noImplicitAny, strictFunctionTypes, etc.

strictNullChecks — treats null and undefined as distinct types:
  let name: string = null; // Error with strictNullChecks on
  let name: string | null = null; // OK

noImplicitAny — error if TypeScript cannot infer the type:
  function greet(name) { ... } // Error: name has implicit any

outDir / rootDir — organise compiled output:
  "rootDir": "./src",
  "outDir": "./dist"

paths — module path aliases (useful with bundlers):
  "paths": {
    "@utils/*": ["./src/utils/*"]
  }

include / exclude — control which files are compiled:
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]

Running in watch mode (recompile on save):
  tsc --watch

With ts-node for scripts:
  npx ts-node --esm src/index.ts'''
      },
    ],
  },
];
