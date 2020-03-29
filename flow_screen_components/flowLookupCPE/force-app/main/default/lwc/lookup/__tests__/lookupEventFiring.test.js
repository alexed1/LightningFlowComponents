import { createElement } from 'lwc';
import Lookup from 'c/lookup';

const SAMPLE_SEARCH_RAW = 'Sample search* ';
const SAMPLE_SEARCH_CLEAN = 'sample search';
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

describe('c-lookup event fires', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('search event fires', () => {
        jest.useFakeTimers();

        // Create element with mock search handler
        const mockSearchFn = jest.fn();
        const element = createElement('c-lookup', {
            is: Lookup
        });
        element.addEventListener('search', mockSearchFn);
        element.isMultiEntry = true;
        element.selection = SAMPLE_SEARCH_ITEMS;
        document.body.appendChild(element);

        // Set search term and force input change
        const searchInput = element.shadowRoot.querySelector('input');
        searchInput.value = SAMPLE_SEARCH_RAW;
        searchInput.dispatchEvent(new CustomEvent('input'));

        // Disable search throttling
        jest.runAllTimers();

        // Check fired search event
        expect(mockSearchFn).toHaveBeenCalledTimes(1);
        const searchEvent = mockSearchFn.mock.calls[0][0];
        expect(searchEvent.detail).toEqual({
            searchTerm: SAMPLE_SEARCH_CLEAN,
            selectedIds: ['id1', 'id2']
        });
    });
});
