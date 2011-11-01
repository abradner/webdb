$(function() {

    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    //
    // Helper functions
    //
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////

    /* this function returns the first numeric value in a string as a number */
    var numericValue = function(value) {
        var digits = value.match(/[0-9]+/);
        if (digits && digits.length > 0) {
            return Number(digits[0]);
        }
        return Number(0);
    };
    /* this function copies the state of the list builder into the listBuilderState hidden input */
    var updateListBuilderState = function() {

        var state = "";

        var selected = $('#rightSelect option');
        for (var i = 0; i < selected.length; i++) {
            var option = selected[i];
            state += option.value;
            if (i < selected.length - 1) {
                state += ',';
            }
        }


        $('#list_selected').val(state);

    };
    /* this function allows the user to tab through buttons to another without firing their onkeyup event handlers */
    var doNotFireOnTab = function(handler) {
        return function(event) {
            var keyCode = event.keyCode;
            // ignore tab and shift-tab
            if (keyCode == 9 || keyCode == 16) {
                return;
            }
            handler(event);
        }
    };
    /* this function returns the handler for up buttons */
    var moveUpHandler = function(selectId) {
        return function(event) {
            var selected = $('#' + selectId + ' option:selected');
            if (selected.length > 0) {
                if (selected[0].index == 0) {
                    return;
                }
                selected.each(function(index) {
                    var i = this.index;
                    var list = $('#' + selectId)[0];
                    var previous = list.options[i - 1];
                    list.remove(i);
                    list.add(this, previous);
                });
            }
            updateListBuilderState();
            this.blur();
        };
    };
    /* this function determines whether or not a value is contained within an array */
    var contains = function(list, value) {
        if (! value) {
            return false;
        }
        for (var i = 0; i < list.length; i++) {
            if (list[i] == value) {
                return true;
            }
        }
        return false;
    };
    /* this function returns the handler for down buttons */
    var moveDownHandler = function(selectId) {
        return function(event) {
            var selected = $('#' + selectId + ' option:selected');
            if (selected.length > 0) {
                var options = $('#' + selectId + ' option');
                if (selected[selected.length - 1].index == options.length - 1) {
                    return;
                }
                var befores = new Array();
                for (var i = 0; i < selected.length; i++) {
                    var currentIndex = selected[i].index;
                    var beforeIndex = currentIndex + 2;
                    var before = options[beforeIndex];
                    for (var j = 1; before; j++) {
                        if (contains(selected, options[currentIndex + j])) {
                            beforeIndex++;
                            before = options[beforeIndex];
                        }
                        else if (before.index > options[currentIndex + j].index) {
                            break;
                        }
                    }
                    befores.push(before ? before : null);
                }
                selected.each(function(index) {
                    list = $('#' + selectId)[0];
                    list.remove(this.index);
                    list.add(this, befores[index]);
                });
            }
            updateListBuilderState();
            this.blur();
        };
    };

    // get height of row
    var divHeight = $('#leftList').height();

    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    //
    // Left Buttons
    //
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    /*
     // center the left buttons vertically
     var leftButtons = $('#leftButtons');
     var leftButtonsHeight = leftButtons.height() + numericValue(leftButtons.css('margin-top')) +
     numericValue(leftButtons.css('margin-bottom')) + numericValue(leftButtons.css('padding-top')) +
     numericValue(leftButtons.css('padding-bottom'));
     var leftButtonsMargin = ((divHeight - leftButtonsHeight) / 2) + 'px';
     leftButtons.css('margin-top', leftButtonsMargin);
     // center the left buttons horizontally
     var leftUpButton = $('#leftUpButton');
     var leftDownButton = $('#leftDownButton');
     var divWidth = leftButtons.width();
     var leftUpMargin = ((divWidth - leftUpButton.width()) / 2) + 'px';
     leftUpButton.css({ 'margin-left': leftUpMargin, 'margin-right': leftUpMargin });
     var leftDownMargin = ((divWidth - leftDownButton.width()) / 2) + 'px';
     leftDownButton.css({ 'margin-left': leftDownMargin, 'margin-right': leftDownMargin });
     // add left button functionality
     var handler = moveUpHandler('leftSelect');
     leftUpButton.click(handler).keyup(doNotFireOnTab(handler));
     handler = moveDownHandler('leftSelect');
     leftDownButton.click(handler).keyup(doNotFireOnTab(handler));
     */
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    //
    // Right Buttons
    //
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    /*
     // center the right buttons vertically
     var rightButtons = $('#rightButtons');
     var rightButtonsHeight = rightButtons.height() + numericValue(rightButtons.css('margin-top')) +
     numericValue(rightButtons.css('margin-bottom')) + numericValue(rightButtons.css('padding-top')) +
     numericValue(rightButtons.css('padding-bottom'));
     var rightButtonsMargin = ((divHeight - rightButtonsHeight) / 2) + 'px';
     rightButtons.css('margin-top', rightButtonsMargin);
     // center the right buttons horizontally
     var rightUpButton = $('#rightUpButton');
     var rightDownButton = $('#rightDownButton');
     divWidth = rightButtons.width();
     var rightUpMargin = ((divWidth - rightUpButton.width()) / 2) + 'px';
     rightUpButton.css({ 'margin-left': rightUpMargin, 'margin-right': rightUpMargin });
     var rightDownMargin = ((divWidth - rightDownButton.width()) / 2) + 'px';
     rightDownButton.css({ 'margin-left': rightDownMargin, 'margin-right': rightDownMargin  });
     // add right button functionality
     handler = moveUpHandler('rightSelect');
     rightUpButton.click(handler).keyup(doNotFireOnTab(handler));
     handler = moveDownHandler('rightSelect');
     rightDownButton.click(handler).keyup(doNotFireOnTab(handler));
     */
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    //
    // Middle Buttons
    //
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////

    // center the middle buttons vertically
    var middleButtons = $('#middleButtons');
    var middleButtonsHeight = middleButtons.height() + numericValue(middleButtons.css('margin-top')) +
        numericValue(middleButtons.css('margin-bottom')) + numericValue(middleButtons.css('padding-top')) +
        numericValue(middleButtons.css('padding-bottom'));
    var middleButtonsMargin = ((divHeight - middleButtonsHeight) / 2) + 'px';
    middleButtons.css('margin-top', middleButtonsMargin);
    // center the middle buttons horizontally
    var addButton = $('#addButton');
    var removeButton = $('#removeButton');
    var addAllButton = $('#addAllButton');
    var removeAllButton = $('#removeAllButton');
    divWidth = middleButtons.width();
    var addMargin = ((divWidth - addButton.width()) / 2) + 'px';
    addButton.css({ 'margin-left': addMargin, 'margin-right': addMargin });
    var removeMargin = ((divWidth - removeButton.width()) / 2) + 'px';
    removeButton.css({ 'margin-left': removeMargin, 'margin-right': removeMargin });
    var addAllMargin = ((divWidth - addAllButton.width()) / 2) + 'px';
    addAllButton.css({ 'margin-left': addAllMargin, 'margin-right': addAllMargin });
    var removeAllMargin = ((divWidth - removeAllButton.width()) / 2) + 'px';
    removeAllButton.css({ 'margin-left': removeAllMargin, 'margin-right': removeAllMargin });
    // add middle button functionality
    handler = function(event) {
        $('#leftSelect option:selected').appendTo('#rightSelect').attr({ selected: false });
        updateListBuilderState();
        this.blur();
    };
    addButton.click(handler).keyup(doNotFireOnTab(handler));
    handler = function(event) {
        $('#rightSelect option:selected').appendTo('#leftSelect').attr({ selected: false });
        updateListBuilderState();
        this.blur();
    };
    removeButton.click(handler).keyup(doNotFireOnTab(handler));
    handler = function(event) {
        $('#leftSelect option').appendTo('#rightSelect').attr({ selected: false });
        updateListBuilderState();
        this.blur();
    };
    addAllButton.click(handler).keyup(doNotFireOnTab(handler));
    handler = function(event) {
        $('#rightSelect option').appendTo('#leftSelect').attr({ selected: false });
        updateListBuilderState();
        this.blur();
    };
    removeAllButton.click(handler).keyup(doNotFireOnTab(handler));

    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    //
    // Selects
    //
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////

    // set the width and height of each select, even when empty
    var leftSelect = $('#leftSelect');
    var rightSelect = $('#rightSelect');
    var selectWidth = Math.max(leftSelect.width(), rightSelect.width());
    var selectHeight = Math.max(leftSelect.height(), rightSelect.height());
    leftSelect.width(selectWidth).height(selectHeight);
    rightSelect.width(selectWidth).height(selectHeight);
    // the right select div must also be set to this width to ensure that the right buttons are placed correctly
    $('#rightList').width(selectWidth);
    // make sure the hidden state input is always up to date
    updateListBuilderState();
    var updateState = function(event) {
        updateListBuilderState();
    };
    leftSelect.click(updateState).keyup(doNotFireOnTab(updateState));
    rightSelect.click(updateState).keyup(doNotFireOnTab(updateState));
});
