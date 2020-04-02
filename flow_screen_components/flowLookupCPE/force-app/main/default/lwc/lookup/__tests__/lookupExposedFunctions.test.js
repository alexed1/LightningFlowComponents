import { createElement } from 'lwc';
import Lookup from 'c/lookup';

const SAMPLE_SEARCH_ITEMS = [
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

describe('c-lookup exposed functions', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('getSelection returns correct selection', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.selection = SAMPLE_SEARCH_ITEMS;

        // Verify selection
        const selection = element.getSelection();
        expect(selection.length).toBe(2);
    });

    it('setSearchResults renders correct results', () => {
        // Create element
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.setSearchResults(SAMPLE_SEARCH_ITEMS);
        document.body.appendChild(element);

        // Query for rendered list items
        const listItemEls = element.shadowRoot.querySelectorAll('li');
        expect(listItemEls.length).toBe(2);
        expect(listItemEls[0].textContent).toBe('Sample item 1sub1');
    });
});
