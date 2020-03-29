import { createElement } from 'lwc';
import Lookup from 'c/lookup';

const SAMPLE_SELECTION_ITEMS = [
    {
        id: 'id1',
        icon: 'standard:default',
        title: 'Sample item 1',
        subtitle: 'sub1'
    },
    {
        id: 'id2',
        icon: 'standard:default',
        title: 'Sample item 2',
        subtitle: 'sub2'
    }
];

describe('c-lookup rendering', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('shows no results by default', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        document.body.appendChild(element);

        // Query for rendered list items
        const listItemEls = element.shadowRoot.querySelectorAll('li');
        expect(listItemEls.length).toBe(1);
        expect(listItemEls[0].textContent).toBe('No results.');
    });

    it('renders label', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.label = 'Sample Lookup';
        document.body.appendChild(element);

        // Verify label
        const detailEl = element.shadowRoot.querySelector('label');
        expect(detailEl.textContent).toBe('Sample Lookup');
    });

    it('does not render label if omitted', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.label = '';
        document.body.appendChild(element);

        // Verify label doesn't exist
        const detailEl = element.shadowRoot.querySelector('label');
        expect(detailEl).toBe(null);
    });

    it('renders single entry (no selection)', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.isMultiEntry = false;
        document.body.appendChild(element);

        // Verify selected icon
        const selIcon = element.shadowRoot.querySelector('lightning-icon');
        expect(selIcon.alternativeText).toBe('Selected item icon');
        // Verify clear selection button
        const clearSelButton = element.shadowRoot.querySelector('button');
        expect(clearSelButton.title).toBe('Remove selected option');
        // Verify result list is NOT rendered
        const selList = element.shadowRoot.querySelectorAll(
            'ul.slds-listbox_inline'
        );
        expect(selList.length).toBe(0);
    });

    it('renders multi entry (no selection)', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.isMultiEntry = true;
        document.body.appendChild(element);

        // Verify selected icon is NOT rendered
        const selIcon = element.shadowRoot.querySelectorAll('lightning-icon');
        expect(selIcon.length).toBe(1);
        // Verify clear selection button is NOT rendered
        const clearSelButton = element.shadowRoot.querySelectorAll('button');
        expect(clearSelButton.length).toBe(0);
        // Verify result list is rendered
        const selList = element.shadowRoot.querySelectorAll(
            'ul.slds-listbox_inline'
        );
        expect(selList.length).toBe(1);
    });

    it('renders title on selection in single-select', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.isMultiEntry = false;
        element.selection = [SAMPLE_SELECTION_ITEMS[0]];
        document.body.appendChild(element);

        const inputBox = element.shadowRoot.querySelector('input');
        expect(inputBox.title).toBe(SAMPLE_SELECTION_ITEMS[0].title);
    });

    it('renders title on selection in multi-select', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.isMultiEntry = true;
        element.selection = SAMPLE_SELECTION_ITEMS;
        document.body.appendChild(element);

        const inputBox = element.shadowRoot.querySelector('input');
        expect(inputBox.title).toBe('');

        const selPills = element.shadowRoot.querySelectorAll('lightning-pill');
        expect(selPills.length).toBe(2);
        expect(selPills[0].title).toBe(SAMPLE_SELECTION_ITEMS[0].title);
        expect(selPills[1].title).toBe(SAMPLE_SELECTION_ITEMS[1].title);
    });

    it('renders errors', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.errors = [
            { id: 'e1', message: 'Sample error 1' },
            { id: 'e2', message: 'Sample error 2' }
        ];
        document.body.appendChild(element);

        // Verify errors
        const errors = element.shadowRoot.querySelectorAll('label.form-error');
        expect(errors.length).toBe(2);
        expect(errors[0].textContent).toBe('Sample error 1');
    });
});
