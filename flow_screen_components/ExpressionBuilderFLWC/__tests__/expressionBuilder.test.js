// hello.test.js
import { createElement } from 'lwc';
import ExpressionBuilder from 'c/expressionBuilder';

describe('c-expression-builder', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('displays greeting', () => {
        // Create element
        const element = createElement('c-expression-builder', {
            is: ExpressionBuilder
        });
        document.body.appendChild(element);

        // Verify displayed greeting
        const div = element.shadowRoot.querySelector('div');
        expect(div.textContent).toBe('Expression Builder!');
    });
});