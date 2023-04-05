/* eslint-env es6 */

module.exports = {
  root: true,
  env: {
    es6: true,
    // es2022: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:@typescript-eslint/recommended',
    // 'plugin:prettier/recommended',
    'prettier',
  ],
  plugins: ['@typescript-eslint', 'prettier'],
  globals: {
    Atomics: 'readonly',
    SharedArrayBuffer: 'readonly',
  },
  parser: '@typescript-eslint/parser',
  rules: {
    // https://eslint.org/docs/latest/rules/

    // ╭─────────────────╮
    // │  Logic Problems │
    // ╰─────────────────╯
    'constructor-super': 'error',
    'for-direction': ['error'],
    'getter-return': ['error'],
    'no-async-promise-executor': [0],
    // 'no-await-in-loop': [],
    'no-class-assign': ['error'],
    'no-compare-neg-zero': ['error'],
    'no-cond-assign': 'error',
    'no-const-assign': ['error'],
    // 'no-constant-binary-expression': [],
    'no-constant-condition': ['error'],
    // 'no-constructor-return': [],
    'no-control-regex': ['error'],
    'no-debugger': 'error',
    'no-dupe-args': ['error'],
    'no-dupe-class-members': [0],
    // 'no-dupe-else-if': [],
    'no-dupe-keys': ['error'],
    'no-duplicate-case': ['error'],
    // 'no-duplicate-imports': [],
    'no-empty-character-class': ['error'],
    'no-empty-pattern': ['error'],
    'no-ex-assign': ['error'],
    'no-fallthrough': 'off',
    'no-func-assign': ['error'],
    // 'no-import-assign': [],
    'no-inner-declarations': ['error'],
    'no-invalid-regexp': ['error'],
    'no-irregular-whitespace': 'error',
    // 'no-loss-of-precision': '',
    'no-misleading-character-class': ['error'],
    // 'no-new-native-nonconstructor': [],
    'no-new-symbol': ['error'],
    'no-obj-calls': ['error'],
    // 'no-promise-executor-return': [],
    'no-prototype-builtins': [0],
    'no-self-assign': ['error'],
    // 'no-self-compare': [],
    // 'no-setter-return': [],
    'no-sparse-arrays': 'error',
    'no-template-curly-in-string': 'off',
    'no-this-before-super': ['error'],
    'no-undef': ['off'],
    'no-unexpected-multiline': ['error'],
    // 'no-unmodified-loop-condition': [],
    'no-unreachable': ['warn'],
    // 'no-unreachable-loop': [],
    'no-unsafe-finally': 'error',
    'no-unsafe-negation': ['error'],
    'no-unsafe-optional-chaining': ['error'],
    // 'no-unused-private-class-members': [],
    'no-unused-vars': [0],
    // 'no-use-before-define': [],
    'no-useless-backreference': 'error',
    'require-atomic-updates': [0],
    'use-isnan': 'error',
    'valid-typeof': 'off',

    // ╭──────────────╮
    // │  Suggestions │
    // ╰──────────────╯
    'accessor-pairs': [
      'error',
      { getWithoutSet: true, setWithoutGet: true, enforceForClassMembers: false },
    ],
    'arrow-body-style': 'off',
    // 'block-scoped-var': '',
    camelcase: 'off',
    'capitalized-comments': 'off',
    // 'class-methods-use-this': [
    //   'error',
    //   {
    //     exceptMethods: {},
    //     enforceForClassFields: true,
    //   },
    // ],
    complexity: 'off',
    // 'consistent-return': 'off',
    // 'consistent-this': ['error', 'that'],
    curly: 'off',
    // 'default-case': 'off',
    'default-case-last': 'error',
    'default-param-last': 'error',
    'dot-notation': 'off',
    eqeqeq: ['off', 'always'],
    // 'func-name-matching': 'off',
    'func-names': [0],
    // 'func-style': [0],
    'grouped-accessor-pairs': ['error', 'getBeforeSet'],
    'guard-for-in': [0],
    'id-denylist': [
      'error',
      'any',
      'Number',
      // 'number',
      'String',
      // 'string',
      'Boolean',
      // 'boolean',
      'Undefined',
    ],
    // 'id-length': '',
    'id-match': 'error',
    // 'init-declarations': 'off',
    // 'logical-assignment-operators': ['error', 'always', { enforceForIfStatements: true }],
    'max-classes-per-file': 'off',
    // 'max-depth': 'off',
    // 'max-lines': 'off',
    // 'max-lines-per-function': 'off',
    // 'max-nested-callbacks': 'off',
    // 'max-params': 'off',
    // 'max-statements': 'off',
    // 'multiline-comment-style': 'off',
    // 'new-cap': 'off',
    // 'no-alert': 'off',
    // 'no-array-constructor': 'off',
    'no-bitwise': 'off',
    'no-caller': 'error',
    'no-case-declarations': ['error'],
    // 'no-confusing-arrow': 'error',
    'no-console': 'off',
    // 'no-continue': 'error',
    'no-delete-var': ['error'],
    'no-div-regex': 'error',
    'no-else-return': ['error', { allowElseIf: true }],
    'no-empty': ['error', { allowEmptyCatch: true }],
    // 'no-empty-function': 'error', MAYBE: change
    // 'no-empty-static-block': 'error', MAYBE: change
    'no-eq-null': 'error',
    'no-eval': 'error',
    // 'no-extend-native': 'error',
    'no-extra-bind': 'error',
    'no-extra-boolean-cast': ['error', { enforceForLogicalOperands: true }],
    'no-extra-label': 'error',
    'no-extra-semi': 'error',
    // 'no-floating-decimal': '',
    'no-global-assign': ['error'],
    'no-implicit-coercion': [
      'error',
      {
        boolean: false,
        number: true,
        string: true,
        disallowTemplateShorthand: true,
        allow: ['~', '!!'],
      },
    ],
    // 'no-implicit-globals': '',
    // 'no-implied-eval': '',
    // 'no-inline-comments': '',
    'no-invalid-this': ['error', { capIsConstructor: true }],
    // 'no-iterator': '',
    'no-label-var': 'error',
    'no-label': ['off'],
    // 'no-lone-blocks': 'off',
    'no-lonely-if': 'error',
    'no-loop-func': 'error',
    'no-magic-numbers': 'off',
    'no-mixed-operators': [
      'error',
      {
        // groups: [
        //   ['+', '-', '*', '/', '%', '**'],
        //   ['&', '|', '^', '~', '<<', '>>', '>>>'],
        //   ['==', '!=', '===', '!==', '>', '>=', '<', '<='],
        //   ['&&', '||'],
        //   ['in', 'instanceof'],
        //   ['??'],
        //   ['?:'],
        // ],
        allowSamePrecedence: true,
      },
    ],
    'no-multi-assign': 'off',
    // 'no-multi-str': 'off',
    'no-negated-condition': 'error',
    'no-nested-ternary': 'off',
    // 'no-new': 'error',
    // 'no-new-func': 'error',
    'no-new-object': 'error',
    'no-new-wrappers': 'error',
    'no-nonoctal-decimal-escape': 'error',
    'no-octal': ['error'],
    'no-octal-escape': 'error',
    // 'no-param-reassign': 'off',
    'no-plusplus': 'off',
    // 'no-proto': 'off',
    'no-redeclare': 'error',
    'no-regex-spaces': ['error'],
    // 'no-restricted-exports': 'error',
    // 'no-restricted-globals': 'error',
    // 'no-restricted-imports': 'error',
    // 'no-restricted-properties': 'error',
    // 'no-restricted-syntax': 'error',
    // 'no-return-assign': 'error',
    'no-return-await': 'error',
    // 'no-script-url': 'error',
    'no-sequences': 'error',
    'no-shadow': ['off', { hoist: 'all' }],
    'no-shadow-restricted-names': ['error'],
    'no-ternary': 'off',
    'no-throw-literal': 'error',
    'no-undef-init': 'error',
    // 'no-undefined': 'error',
    'no-underscore-dangle': 'off',
    'no-unneeded-ternary': 'error',
    'no-unused-expressions': 'off',
    'no-unused-labels': 'error',
    // 'no-useless-call': ['error'],
    'no-useless-catch': ['error'],
    // 'no-useless-computed-key': 'error',
    'no-useless-concat': 'error',
    // 'no-useless-constructor': 'error',
    'no-useless-escape': ['error'],
    'no-useless-rename': ['error'],
    'no-useless-return': 'error',
    'no-var': 'error',
    'no-void': 'off',
    'no-warning-comments': 'off',
    'no-with': ['error'],
    'object-shorthand': 'error',
    'one-var': ['error', 'never'],
    // 'one-var-declaration-per-line': '',
    // 'operator-assignment': 'off',
    // 'prefer-arrow-callback': 'error',
    'prefer-const': ['error', { destructuring: 'all', ignoreReadBeforeAssign: false }],
    // 'prefer-destructuring': 'off',
    // 'prefer-exponentiation-operator': 'off',
    // 'prefer-named-capture-group': [0],
    // 'prefer-numeric-literals': [0],
    'prefer-object-has-own': 'error', // REQUIRES: es2022
    'prefer-object-spread': 'error',
    'prefer-promise-reject-errors': ['error', { allowEmptyReject: true }],
    'prefer-regex-literals': ['error', { disallowRedundantWrapping: true }],
    'prefer-rest-params': [0],
    'prefer-spread': [0],
    'prefer-template': 'error',
    'quote-props': ['error', 'as-needed'],
    radix: 'error',
    // 'require-await': 'error',
    // 'require-unicode-regexp': 'off',
    'require-yield': ['error'],
    'sort-imports': [
      'error',
      {
        ignoreCase: false,
        ignoreDeclarationSort: false,
        ignoreMemberSort: false,
        memberSyntaxSortOrder: ['none', 'all', 'multiple', 'single'],
        allowSeparatedGroups: true,
      },
    ],
    // 'sort-keys': 'off',
    // 'sort-vars': 'off',
    'spaced-comment': ['error', 'always', { markers: ['/'] }],
    // 'strict': 'error',
    // 'symbol-description': '',
    // 'vars-on-top': '',
    // 'yoda': '',

    // ╭──────────────────────╮
    // │  Layout / Formatting │
    // ╰──────────────────────╯
    'array-bracket-newline': ['error', { multiline: true }],
    // 'array-bracket-spacing': ['error', 'always', { singleValue: false, arraysInArrays: false }],
    'array-element-newline': ['error', 'consistent', { multiline: true }],
    'arrow-parens': ['error', 'as-needed', { requireForBlockBody: true }],
    'arrow-spacing': ['error', { before: true, after: true }],
    'block-spacing': ['error', 'always'],
    'brace-style': ['error', '1tbs'],
    'comma-dangle': ['error', 'always-multiline'],
    // 'comma-spacing': ['error', {before: false, after: true}],
    'comma-style': ['error', 'last'],
    'computed-property-spacing': ['error', 'never'],
    'dot-location': ['error', 'object'],
    'eol-last': 'off',
    'func-call-spacing': ['error', 'never'],
    'function-call-argument-newline': ['error', 'consistent'],
    // 'function-paren-newline': ['error', 'multiline'],
    'function-paren-newline': ['error', 'multiline-arguments'],
    'generator-star-spacing': ['error', 'before'],
    'implicit-arrow-linebreak': ['error', 'beside'],
    // indent: ['error', 4],
    'jsx-quotes': ['error', 'prefer-double'],
    // 'key-spacing': [],
    // 'keyword-spacing': [],
    // 'line-comment-position': [],
    'linebreak-style': [1, 'unix'],
    // 'lines-around-comment': [],
    // 'lines-between-class-members': [],
    'max-len': ['error', { code: 100, tabWidth: 2 }],
    // 'max-statements-per-line': ['error', { 'max': 2 }],
    'multiline-ternary': ['error', 'always-multiline'],
    'new-parens': ['error', 'never'],
    'newline-per-chained-call': ['error', { ignoreChainWithDepth: 2 }],
    'no-extra-parens': [
      'error',
      'all',
      {
        conditionalAssign: false,
        returnAssign: false,
        nestedBinaryExpressions: false,
        ignoreJSX: 'multi-line',
        enforceForNewInMemberExpressions: false,
        enforceForFunctionPrototypeMethods: false,
        enforceForSequenceExpressions: false,
        enforceForArrowConditionals: false,
      },
    ],
    'no-mixed-spaces-and-tabs': ['error'],
    // 'no-multi-spaces': ['error'],
    'no-multiple-empty-lines': ['error', { max: 2 }],
    'no-tabs': 'error',
    'no-trailing-spaces': 'error',
    'no-whitespace-before-property': 'error',
    'nonblock-statement-body-position': ['error', 'below'],
    'object-curly-newline': ['error', { multiline: true }],
    // 'object-property-newline': ['error'],
    'operator-linebreak': ['error', 'after'],
    // 'padded-blocks': [],
    // 'padding-line-between-statements': [],
    quotes: ['error', 'single', { avoidEscape: true, allowTemplateLiterals: true }],
    'rest-spread-spacing': ['error'],
    semi: ['error', 'always', { omitLastInOneLineBlock: true }],
    // 'semi-spacing': [],
    'semi-style': ['error', 'last'],
    'space-before-blocks': ['error', 'always'],
    'space-before-function-paren': [
      'error',
      { anonymous: 'never', named: 'never', asyncArrow: 'always' },
    ],
    'space-in-parens': ['error', 'never'],
    'space-infix-ops': 'error',
    'space-unary-ops': ['error', { words: true, nonwords: false }],
    'switch-colon-spacing': ['error', { after: true, before: false }],
    'template-curly-spacing': ['error', 'never'],
    'template-tag-spacing': ['error', 'never'],
    // 'unicode-bom': 'never',
    'wrap-iife': ['error', 'inside', { functionPrototypeMethods: true }],
    'wrap-regex': 'error',
    'yield-star-spacing': ['error', 'after'],

    // ╭────────╮
    // │  JSDoc │
    // ╰────────╯
    // https://www.npmjs.com/package/eslint-plugin-jsdoc
    'jsdoc/check-access': 'error',
    'jsdoc/check-alignment': 'error',
    'jsdoc/check-examples': 'error',
    'jsdoc/check-indentation': 'error',
    // 'jsdoc/check-line-alignment': 'error',
    // 'jsdoc/check-param-names': 'error',

    // 'jsdoc/newline-after-description': 'error',

    // ╭────────────────────╮
    // │  Typescript ESLint │
    // ╰────────────────────╯
    // https://typescript-eslint.io/rules/
    '@typescript-eslint/no-empty-function': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
    '@typescript-eslint/no-inferrable-types': 'warn',
    '@typescript-eslint/no-namespace': 'off',
    '@typescript-eslint/no-non-null-assertion': 'off',

    '@typescript-eslint/ban-ts-comment': 'off',
    '@typescript-eslint/ban-types': 'off',
    '@typescript-eslint/prefer-namespace-keyword': 'warn',
    '@typescript-eslint/quotes': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/explicit-member-accessibility': ['error', { accessibility: 'no-public' }],
    '@typescript-eslint/explicit-function-return-type': [
      'warn',
      {
        allowExpressions: true,
        allowTypedFunctionExpressions: true,
      },
    ],
    '@typescript-eslint/no-unused-vars': [
      'warn',
      {
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_',
      },
    ],
  },
  overrides: [
    {
      files: ['*.js?(x)'],
      // extends: [],
    },
    {
      files: ['*.ts?(x)'],
      parserOptions: {
        ecmaVersion: 2022,
        project: './tsconfig.json',
      },
    },
    {
      files: ['*.test.ts?(x)'],
      extends: ['plugin:jest/recommended'],
      env: { jest: true },
    },
  ],
};
