<app>
    <div class="file-field input-field">
        <div class="btn" onclick={open_input_dialog}>
            <span><i class="material-icons left">keyboard_voice</i>入力ファイル名</span>
        </div>
        <div class="file-path-wrapper">
            <input class="file-path validate" type="text" id="input" value="">
        </div>
    </div>

    <div class="file-field input-field">
        <div class="btn" onclick={open_save_dialog}>
            <span><i class="material-icons left">insert_drive_file</i>出力ファイル名</span>
        </div>
        <div class="file-path-wrapper">
            <input class="file-path validate" type="text" id="output" value="">
        </div>
    </div>

    <div class="btn pink lighten-3 { isSynthesising ? 'disabled': ''}" style="width: 100%;" onclick={click_synth}>
        <span><i class="material-icons">sync</i>変換</span>
    </div>

    <ul class="collapsible" data-collapsible="accordion">
        <li>
            <div class="collapsible-header">
                オプション<span class="badge"><i class="material-icons">add_circle_outline</i></span>
            </div>
            <div class="collapsible-body">
                <label for="order">LPC次数</label>
                <input id="order" class="validate" type="number" min="0" value="0">
                <label for="rate">有声音割合</label>
                <input id="rate" class="validate" type="number" min="0.0" max="1.0" step="any" value="0.0">
                <label for="hpf">プリエンファシスフィルタ係数</label>
                <input id="hpf" class="validate" type="number" min="0.0" max="1.0" step="any" value="0.97">
                <label for="lpf">デエンファシスフィルタ係数</label>
                <input id="lpf" class="validate" type="number" min="0.0" max="1.0" step="any" value="0.97">
                <label for="framet">フレーム幅[ms]</label>
                <input id="framet" class="validate" type="number" min="0.0" step="any" value="20.0">

                <div class="file-field input-field">
                    <div class="btn" onclick={open_vowel_save_dialog}>
                        <span><i class="material-icons left">insert_drive_file</i>声帯音源出力ファイル名</span>
                    </div>
                    <div class="file-path-wrapper">
                        <input class="file-path validate" type="text" id="vowel_output">
                    </div>
                </div>
                <div style="display: flex; justify-content: flex-end;">
                <div class="btn red accent-3" onclick={reset_parameters}>
                    <span><i class="material-icons left">clear</i>設定の初期化</span>
                </div>
                </div>
            </div>
        </li>
    </ul>

    <script>
    const fileSystem = require('fs');
    const path = require('path');
    const Dialog = require('electron').remote.dialog;
    const {ipcRenderer} = require('electron');

    isSynthesising = false;

    function bindSaveFileName(file_name, isNormalOutput) {
        if (isNormalOutput === undefined || isNormalOutput === true) {
            document.querySelector('#output').value = file_name;
        } else {
            document.querySelector('#vowel_output').value = file_name;
        }
    }

    function is_parameter_valid(selector) {
        return document.querySelector(selector).validity.valid;
    }

    function conv_to_num(selector) {
        return document.querySelector(selector).value + '';
    }

    function set_parameters() {
        let params = {};
        if (is_parameter_valid('#order') === true) {
            params['order'] = conv_to_num('#order');
        }
        if (is_parameter_valid('#rate') === true) {
            params['rate'] = conv_to_num('#rate');
        }
        if (is_parameter_valid('#hpf') === true) {
            params['hpf'] = conv_to_num('#hpf');
        }
        if (is_parameter_valid('#lpf') === true) {
            params['lpf'] = conv_to_num('#lpf');
        }
        if (is_parameter_valid('#framet') === true) {
            params['framet'] = conv_to_num('#framet');
        }

        let p = new Promise((resolve, reject) => {
            ipcRenderer.once('set_parameters', (event, args) => {
                resolve();
            });
        });

        ipcRenderer.send('set_parameters', params);

        return p;    
    }

    function do_synth() {
        let params = {};
        params['dummy'] = null;
        let p = new Promise((resolve, reject) => {
            let input = document.querySelector('#input').value;
            if (input == '') {
                reject({
                    type: 'f_error',
                    detail: '入力ファイルパラメータが不正です',
                });
                return;
            }
            params['input_file'] = input;

            let output = document.querySelector('#output').value;
            if (output == '') {
                reject({
                    type: 'f_error',
                    detail: '出力ファイルパラメータが不正です',
                });
                return;
            }
            params['output_file'] = output;

            let vowel_output = document.querySelector('#vowel_output').value;
            if (vowel_output !== '') {
                parameter['vowel_output'] = vowel_output;
            }

            ipcRenderer.once('done_synth', (event, args) => {
                if (args.error !== undefined) {
                    reject({
                        type: 'p_error',
                        detail: `変換に失敗しました, ${args.error}`,
                    });
                    return;
                }

                resolve({
                    type: 'success',
                    detail: '変換が完了しました',
                });
            });
            ipcRenderer.send('do_synth', params);
        });

        return p;
    }

    click_synth() {
        isSynthesising = true;
        this.update();
        set_parameters()
        .then((_) => {
            return do_synth();
        })
        .then((result) => {
            Materialize.toast(result.detail, 3000);
        })
        .catch((err) => {
            Materialize.toast(err.detail, 3000);
        })
        .then((_) => {
            isSynthesising = false;
            this.update();
        });
    }

    open_input_dialog() {
        Dialog.showOpenDialog(null, {
            title: '入力ファイルの選択',
            defaultPath: '.',
            filters: [
                {name: 'wavファイル', extensions: ['wav']},
            ]
        }, (file_name) => {
            if (file_name === undefined) return;
            document.querySelector('#input').value = file_name;
        })
    }

    open_save_dialog() {
        Dialog.showSaveDialog(null, {
            title: '音声の保存',
            defaultPath: '.',
            filters: [
                {name: 'wavファイル', extensions: ['wav']},
            ]
        }, (file_name) => {
            if (file_name === undefined) return;
            bindSaveFileName(file_name);
        })
    }

    open_vowel_save_dialog() {
        Dialog.showSaveDialog(null, {
            title: '声帯音源の保存',
            defaultPath: '.',
            filters: [
                {name: 'wavファイル', extensions: ['wav']},
            ]
        }, (file_name) => {
            if (file_name === undefined) return;
            bindSaveFileName(file_name, false);
        })
    }

    reset_parameters() {
        ipcRenderer.send('reset_parameters', null);
        document.querySelector('#order').value = 0;
        document.querySelector('#rate').value = 0.0;
        document.querySelector('#hpf').value = 0.97;
        document.querySelector('#lpf').value = 0.97;
        document.querySelector('#framet').value = 20.0;
    }
    </script>
</app>
